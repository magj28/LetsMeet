var Chat = require("../model/chat");

//get all conversations of userID with particular user
exports.getChats = async (req, res) => {
    let user1ID = req.body.user1ID;
    let user2ID = req.body.user2ID;

    //storing in the database
    var resp1 = await Chat.findOne({ "user2ID": user2ID, "user1ID": user1ID })
    var resp2 = await Chat.findOne({ "user2ID": user1ID, "user1ID": user2ID })

    if (!resp1 && !resp2) {
        const newMessage = new Chat({
            "user1ID": user1ID,
            "user2ID": user2ID,
            "Updated At": Date.now()
        })
        await Chat.create(newMessage)
    }

    var chatMessagesofuser1 = await Chat.findOne({ "user2ID": user2ID, "user1ID": user1ID })
    var chatMessagesofuser2 = await Chat.findOne({ "user2ID": user1ID, "user1ID": user2ID })
    var recentMessagesofuser = chatMessagesofuser1 != null ? chatMessagesofuser1 : chatMessagesofuser2;

    return res.status(200).json({
        status: "success",
        message: "Recent Messages",
        recentMessages: recentMessagesofuser
    })
}

//get all conversations of userID
exports.getAllChats = async (req, res) => {
    let userID = req.params.userID;

    var chatMessages = await Chat.find({ $or: [{ "user2ID": userID }, { "user1ID": userID }] }).sort({ "Updated At": -1 });

    chatMessages = chatMessages.filter(eachChat =>
        eachChat["Chats"].length > 0
    )

    return res.status(200).json({
        status: "success",
        message: "Recent Messages",
        allChats: chatMessages
    })
}