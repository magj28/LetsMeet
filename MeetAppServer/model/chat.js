const mongoose = require('mongoose')

const SingleChatSchema = new mongoose.Schema({
    "senderID": {
        type: String,
    },
    "message": {
        type: String,
    },
    "Date": {
        type: Date,
        default: Date.now()
    },
})

const ChatSchema = new mongoose.Schema({
    "user1ID": {
        type: String,
    },
    "user2ID": {
        type: String,
    },
    "Chats": [SingleChatSchema],
    "Updated At": {
        type: Date
    }
})

const Chat = mongoose.model('Chat', ChatSchema);
module.exports = Chat;