const express = require("express");
const router = express.Router();

const userController= require('../controllers/userController');

router.post("/login", userController.login);
router.get("/getUserData/:userID", userController.getData);
router.get("/usernameCheck/:username", userController.checkUserNameUnique);
router.get("/emailCheck/:email", userController.checkEmailUnique);
router.get("/findName/:userID", userController.findName);
router.post("/signUp", userController.signUp);
router.get("/getAllUsers/:userID", userController.getAllUsers);
router.post("/edit/:userID", userController.edit_information);


module.exports = router;