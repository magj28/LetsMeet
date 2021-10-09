const express = require("express");
const router = express.Router();

const callRecordController= require('../controllers/callRecordController');

router.post("/single", callRecordController.fetchCallRecord);
router.post("/new", callRecordController.CallRecordBeginning);
router.post("/end", callRecordController.CallRecordEnding);
router.get("/getCallRecords/:userID", callRecordController.getCallLogs);

module.exports = router;