//model to store call details of user
class CallRecord {
  String id;
  String receiverID;
  String callerID;
  String duration;
  String date;
  String dateIST;
  String startingTime;
  String status;

  CallRecord(
      {required this.id,
      required this.receiverID,
      required this.callerID,
      required this.duration,
      required this.date,
      required this.dateIST,
      required this.startingTime,
      required this.status});

  factory CallRecord.fromJson(Map<dynamic, dynamic> json) {
    return CallRecord(
        id: json['_id'],
        receiverID: json['Caller ID'],
        callerID: json['Receiver ID'],
        duration: json['Duration'],
        date: json["Date"],
        dateIST: json['Date IST'],
        startingTime: json['Starting Time'],
        status: json["Status"]);
  }
}
