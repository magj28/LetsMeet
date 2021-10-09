const User = require('../model/users');

//login api
exports.login = async (req, res) => {
    var username = req.body.username
    var password = req.body.password

    let resp = await User.findOne({ "Username": username, "Password": password, "Active (Y/N)": 'Y' });

    if (!resp) {
        return res.status(200).json({
            status: "success",
            message: "User or Password incorrect",
            data: {
                User: []
            }
        })
    }
    else {
        return res.status(200).json({
            status: "success",
            message: "User login",
            data: {
                User: resp
            }
        })
    }
}

//gets user data
exports.getData = async (req, res) => {
    var userID = req.params.userID

    let resp = await User.findOne({ _id: userID, "Active (Y/N)": 'Y' });


    return res.status(200).json({
        status: "success",
        message: "User login",
        data: {
            User: resp
        }
    })
}

//to check if username already exists
exports.checkUserNameUnique = async (req, res) => {
    var username = req.params.username

    let resp = await User.findOne({ "Username": username, "Active (Y/N)": 'Y' });

    if (!resp) {
        return res.status(200).json({
            status: "success",
            message: "Username available",
        })
    }
    else {
        return res.status(200).json({
            status: "success",
            message: "Username not available",
        })
    }
}

//to check if email already exists
exports.checkEmailUnique = async (req, res) => {
    var email = req.params.email

    let resp = await User.findOne({ "Email": email, "Active (Y/N)": 'Y' });

    if (!resp) {
        return res.status(200).json({
            status: "success",
            message: "Email available",
        })
    }
    else {
        return res.status(200).json({
            status: "success",
            message: "Email not available",
        })
    }
}

//sign up api
exports.signUp = async (req, res) => {
    var firstname = req.body.firstname
    var lastname = req.body.lastname
    var username = req.body.username
    var password = req.body.password
    var email = req.body.email

    const user = new User({
        "First Name": firstname,
        "Last Name": lastname,
        "Email": email,
        "Username": username,
        "Password": password,
        "Active (Y/N)": 'Y',
        "Start Date": Date.now(),
    })

    user.save((err, User) => {
        if (err) {
            return res.json({
                status: "failure",
                message: "Some error occurred in creating the new User",
                error: err,
            })
        }
        return res.status(200).json({
            status: "success",
            message: "New User created",
            data: {
                User: User
            }
        })
    })
}

//find first and last name by id given
exports.findName = async (req, res) => {

    let resp = await User.findOne({ _id: req.params.userID, "Active (Y/N)": 'Y' });

    if (resp) {
        return res.status(200).json({
            status: "success",
            firstname: resp["First Name"],
            lastname: resp["Last Name"],
            message: "Name fetched successfully",
        })
    }
    else {
        return res.status(200).json({
            status: "success",
            message: "Error in fetching name",
        })
    }
}

//get all users 
exports.getAllUsers = async (req, res) => {

    let resp = await User.find({ _id: { $nin: req.params.userID }, "Active (Y/N)": 'Y' }).sort({ "First Name": 1, "Last Name": 1 });

    if (resp) {
        return res.status(200).json({
            status: "success",
            users: resp,
            message: "Fetched all users successfully",
        })
    }
    else {
        return res.status(200).json({
            status: "success",
            message: "Error in fetching users",
        })
    }
}

//edit first name and last name in user profile
exports.edit_information = async (req, res) => {
    await User.findOneAndUpdate(
        {
            _id: req.params.userID
        }, {
        "First Name": req.body.firstName,
        "Last Name": req.body.lastName
    },
        { new: true },
        async (err, User) => {
            if (err) {
                return res.json({
                    status: "failure",
                    message: "Some error occurred in adding information",
                    error: err,
                })
            }
            await res.status(200).json({
                status: "success",
                message: "User details added",
                User: User,
            })
        }
    )
}