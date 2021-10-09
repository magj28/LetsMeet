const CallRecord = require('../model/callRecords');

//get call record of ongoing call
exports.fetchCallRecord = async (req, res) => {
    var receiverID = req.body.receiverID
    var callerID = req.body.callerID

    let resp = await CallRecord.find({ $or: [{ "Caller ID": callerID, "Receiver ID": receiverID }, { "Caller ID": receiverID, "Receiver ID": callerID }] }).sort({ "Date": -1 });

    return res.status(200).json({
        status: "success",
        message: "Call Record created",
        data: {
            CallRecord: resp[0]
        }
    })

}

//post beginning of call
exports.CallRecordBeginning = async (req, res) => {
    var dateIST = new Date().toLocaleString('en-US', { timeZone: 'Asia/Kolkata' })
    var date = dateIST.split(", ");

    var receiverID = req.body.receiverID
    var callerID = req.body.callerID
    var status = req.body.status
    var channel = req.body.channel
    var token = req.body.token

    const callrecord = new CallRecord({
        "Channel": channel,
        "Token": token,
        "Caller ID": callerID,
        "Receiver ID": receiverID,
        "Date": Date.now(),
        "Date IST": date[0],
        "Starting Time": date[1],
        "Status": status
    })

    callrecord.save((err, CallRecord) => {
        if (err) {
            return res.json({
                status: "failure",
                message: "Some error occurred in creating call Record",
                error: err,
            })
        }
        return res.status(200).json({
            status: "success",
            message: "Call Record created",
            data: {
                CallRecord: CallRecord
            }
        })
    })
}

//post ending of call
exports.CallRecordEnding = async (req, res) => {
    var startdate = Date.parse(req.body.date);
    var enddate = Date.now()

    var delta = (enddate - startdate) / 1000

    // calculate (and subtract) whole hours
    var hours = Math.floor(delta / 3600) % 24;
    delta -= hours * 3600;

    // calculate (and subtract) whole minutes
    var minutes = Math.floor(delta / 60) % 60;
    delta -= minutes * 60;

    // what's left is seconds
    var seconds = delta % 60;  // in theory the modulus is not required

    var hrs = (parseInt(hours) < 10 ? '0' : '') + parseInt(hours)
    var min = (parseInt(minutes) < 10 ? '0' : '') + parseInt(minutes)
    var sec = (parseInt(seconds) < 10 ? '0' : '') + parseInt(seconds)

    var id = req.body.id

    CallRecord.findOneAndUpdate({
        _id: id
    }, {
        "Duration": hrs + ":" + min + ":" + sec
    }, { new: true }, async (err, CallRecord) => {
        if (err) {
            return res.json({
                status: "failure",
                message: "Some error occurred in creating call Record",
                error: err,
            })
        }
        return res.status(200).json({
            status: "success",
            message: "Call Record created",
            data: {
                CallRecord: CallRecord
            }
        })
    })
}

//fetching all call logs of user
exports.getCallLogs = async (req, res) => {

    var userID = req.params.userID

    let resp = await CallRecord.find({ $or: [{ "Caller ID": userID }, { "Receiver ID": userID }] })

    return res.status(200).json({
        status: "success",
        message: "Call Record created",
        data: {
            CallRecord: resp
        }
    })
}