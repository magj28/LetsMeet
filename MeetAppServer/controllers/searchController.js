const User = require('../model/users');

//search by keyword
exports.search = async (req, res) => {

    await User.find({_id:{$nin: req.params.id},
        $or:
            [{ "Username": { '$regex': req.params.keyword, '$options': 'i' } }, { "First Name": { '$regex': req.params.keyword, '$options': 'i' } }, { "Last Name": { '$regex': req.params.keyword, '$options': 'i' } }, { "Phone Number": { '$regex': req.params.keyword, '$options': 'i' } }],
    }, async (err, users) => {
        if (err) {
            return res.json({
                status: "failure",
                message: "Some error occurred in searching user",
                error: err,
            })
        }

        res.json({
            status: "success",
            message: "search successful",
            users: users
        })
    })
}