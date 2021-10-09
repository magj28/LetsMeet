const express = require('express');
const app = express();
server = require('http').createServer(app);
require('dotenv').config();

const bodyParser = require('body-parser');

var SocketIO = require("socket.io")

var PORT = process.env.PORT || 3000;

var memCache_1 = require("./controllers/memCacheController");
var events_1 = require("./controllers/eventController");
var chats_1 = require('./controllers/chatController');

const mongoose = require('mongoose');
const uri = process.env.MONGODB_URI// || "mongodb+srv://hemangijain:********@cluster0.snkm8.mongodb.net/LetsMeet?retryWrites=true&w=majority";
//const uri = 'mongodb://localhost:27017/MeetApp'

mongoose.connect(uri, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
    useFindAndModify: false,
    useCreateIndex: true
});
const db = mongoose.connection;
db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', function () {
    console.log('Connected correctly to server');
});

//Importing controllers
const userRoute = require('./routes/user');
const searchRoute = require('./routes/search');
const callRecordRoute = require('./routes/callRecord');
const chatRoute = require('./routes/chat');

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

//initializing routes
app.use('/user', userRoute);
app.use('/search', searchRoute);
app.use('/callRecord', callRecordRoute);
app.use('/chat', chatRoute);

//404 page
app.use((req, res) => {
    res.status(404).json({
        status: "failure",
        message: "This route does not exist",
        data: null
    })
})


const Server = server.listen(PORT, () => {
    console.log(`Listening on ${PORT}`)
});

const io = SocketIO.listen(Server, {
    transports: ["websocket", "polling"],
});

var socketids=[]; //stores user id and their sokcets
var socketconnections=[]; //stores user id and id of chat user is connected to

const nsp = io.of("/chat");

nsp.use(async (socket, next) => {
    const token = socket.handshake.query.id;
    if (token) {
        socket.user = {};
        socket.user.id = token;
        next();
    }
}).on('connection', (socket) => {
    socketids[socket.handshake.query.id]=socket.id
    memCache_1.MemCache.hset(process.env.CHAT_SOCKET, socket.user.id, socket.id);
    const socketEvents = new events_1.SocketEvents();
    socketEvents.init(nsp, socket, socketids, socketconnections);
})
