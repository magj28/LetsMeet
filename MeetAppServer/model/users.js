const mongoose = require('mongoose')

const UserSchema = new mongoose.Schema({
    "First Name": {
        type: String,
    },
    "Last Name": {
        type: String,
    },
    "Email": {
        type: String,
    },
    "Username": {
        type: String,
    },
    "Password": {
        type: String,
    },
    "Country Code": {
        type: String,
    },
    "Mobile Number": {
        type: String,
    },
    "Active (Y/N)": {
        type: String,
        enum: ['Y', 'N']
    },
    "Start Date": {
        type: Date,
        required: true,
    },
    "End Date": {
        type: Date,
    },
})

const User = mongoose.model('User', UserSchema);
module.exports = User;