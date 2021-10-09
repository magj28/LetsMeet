const mongoose = require('mongoose')

const CallRecordSchema = new mongoose.Schema({
    "Channel": {
        type: String,
    },
    "Token": {
        type: String,
    },
    "Caller ID": {
        type: String,
    },
    "Receiver ID": {
        type: String,
    },
    "Duration": {
        type: String,
    },
    "Date": {
        type: Date
    },
    "Date IST": {
        type: String
    },
    "Starting Time": {
        type: String
    },
    "Status": {
        type: String,
        enum: ["Accepted", "Rejected"]
    }
})

const CallRecord = mongoose.model('CallRecord', CallRecordSchema);
module.exports = CallRecord;