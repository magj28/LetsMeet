Object.defineProperty(exports, "__esModule", { value: true });
exports.SocketEvents = void 0;

var uuid = require("node-uuid");
var agora_1 = require("./agoraController");
var memCache_1 = require("./memCacheController");
var Chat = require("../model/chat");
const User = require('../model/users');

var SocketEvents = /** @class */ (function () {
    function SocketEvents() {
        this.agora = new agora_1.Agora();
    }
    SocketEvents.prototype.init = function (nsp, socket, socketids, socketconnections) {
        this.nsp = nsp;
        this.socket = socket;
        this.socketids = socketids;
        this.socketconnections = socketconnections;
        this.listenEvents();
    };
    SocketEvents.prototype.listenEvents = function () {
        this.connectCall();
        this.acceptCall();
        this.rejectCall();
        this.connectMessage();
        this.disconnectMessage();
        this.message();
    };


    /**
     * @param id // other user id
     * @param firstName // other user's first name
     * @param lastName // other user's last name
     * @param channel // ongoing video call's channel
     * @param token // ongoing video call's token
     * use to connect call
     */
    SocketEvents.prototype.connectCall = function () {
        this.socket.on("connectCall", async (data) => {
            const me = this.socket.user.id;
            if (data.token == null) {
                data.channel = uuid.v1();
                data.token = agora_1.Agora.generateToken(data.channel);
            }
            let resp = await User.findOne({ _id: me, "Active (Y/N)": 'Y' });
            data.firstName = resp["First Name"]
            data.lastName = resp["Last Name"]
            const recSocket = memCache_1.MemCache.hget(process.env.CHAT_SOCKET, `${data.id}`);
            if (recSocket) {
                data.id = me;
                this.nsp.to(recSocket).emit("onCallRequest", data);
            }
        })
    };


    /**
     * @param id // other user id
     * @param channel
     * @param token
     * use to accept call
     */
    SocketEvents.prototype.acceptCall = function () {
        this.socket.on("acceptCall", async (data) => {
            const me = this.socket.user.id;
            data.otherUserId = me;
            const recSocket = memCache_1.MemCache.hget(process.env.CHAT_SOCKET, `${data.id}`);
            if (recSocket) {
                this.nsp.to(recSocket).emit("onAcceptCall", data);
            }
        })
    };


    /**
     * @param id // other user id
     * use to reject call
    */
    SocketEvents.prototype.rejectCall = function () {
        this.socket.on("rejectCall", async (data) => {
            const me = this.socket.user.id;
            const recSocket = memCache_1.MemCache.hget(process.env.CHAT_SOCKET, `${data.id}`);
            if (recSocket) {
                const res = { msg: "call disconnected" };
                this.nsp.to(recSocket).emit("onRejectCall", res);
            }
        })
    };

    /**
     * @param id // other user id
     * use to create chat connection
    */
    SocketEvents.prototype.connectMessage = function () {
        this.socket.on("connectMessage", async (data) => {
            const me = this.socket.user.id;
            const other = data.otherUserId;
            this.socketconnections[me] = other
            const res = { msg: "connected" };
            this.socket.emit("onConnectMessage", res);
        })
    };

    /**
     * @param id // other user id
     * use to destroy chat connection
    */
    SocketEvents.prototype.disconnectMessage = function () {
        this.socket.on("disconnectMessage", async (data) => {
            const me = this.socket.user.id;
            this.socketconnections[me] = null
            const res = { msg: "disconnected" };
            this.socket.emit("onDisconnectMessage", res);
        })
    };

    /**
     * @param user1ID // user id
     * @param user2ID // other user id
     * @param senderID // sender's id
     * @param message // message
     * use tosend message
    */
    SocketEvents.prototype.message = function () {
        this.socket.on('message', async (data) => {
            //recieves message from client-end along with sender's and reciever's details
            let user1ID = data.user1ID;
            let user2ID = data.user2ID;
            let senderID = data.senderID;
            let message = data.message;

            //storing in the database
            var resp1 = await Chat.findOne({ "user2ID": user2ID, "user1ID": user1ID })
            var resp2 = await Chat.findOne({ "user2ID": user1ID, "user1ID": user2ID })

            // Check for name and message
            if (message != null) {
                if (!resp1 && resp2) {
                    await Chat.findOneAndUpdate({ "user2ID": user1ID, "user1ID": user2ID }, {
                        "Updated At": Date.now(),
                        $push: {
                            "Chats": [{
                                "senderID": senderID,
                                "message": message,
                                "Date": Date.now(),
                            }],
                        }
                    })
                }
                else if (resp1 && !resp2) {
                    await Chat.findOneAndUpdate({ "user2ID": user2ID, "user1ID": user1ID }, {
                        "Updated At": Date.now(),
                        $push: {
                            "Chats": [{
                                "senderID": senderID,
                                "message": message,
                                "Date": Date.now(),
                            }],
                        }
                    })
                }
                else {
                    const newMessage = new Chat({
                        "user1ID": user1ID,
                        "user2ID": user2ID,
                        "Chats": [{
                            "senderID": senderID,
                            "message": message,
                            "Date": Date.now(),
                        }],
                        "Updated At": Date.now()
                    })
                    // Insert message
                    await Chat.create(newMessage)
                }
            }

            if (resp1 != null || resp2 != null) {
                var chatMessagesofuser1 = await Chat.findOne({ "user2ID": user2ID, "user1ID": user1ID })
                var chatMessagesofuser2 = await Chat.findOne({ "user2ID": user1ID, "user1ID": user2ID })
                var recentMessagesofuser = chatMessagesofuser1 != null ? chatMessagesofuser1 : chatMessagesofuser2;
            }

            //if both users present in socket connections 
            //and connected to each other
            if (this.socketconnections[user2ID] == user1ID)
                this.nsp.to(this.socketids[user2ID]).to(this.socketids[user1ID]).emit('onMessage', recentMessagesofuser)
            else
                this.nsp.to(this.socketids[user1ID]).emit('onMessage', recentMessagesofuser)
        });
    }
    return SocketEvents;
}());
exports.SocketEvents = SocketEvents;