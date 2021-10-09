var express = require('express')
const chatController = require('../controllers/chatController')
var router = express.Router()

router.post("/getChats", chatController.getChats);
router.get("/all/:userID", chatController.getAllChats)


module.exports = router