import 'package:flutter/cupertino.dart';
import 'package:meetapp/logic/model/CallRecord.dart';
import 'package:meetapp/services/webApi.dart';

class CallRecordViewModel with ChangeNotifier {
  WebApi api = WebApi();

  List<CallRecord>? _callRecordsList = []; //stores all call records of user
  CallRecord? _callRecord; //to store call record of ongoing call
  bool _isFetchingData = false;
  String _errorMessage = '';

  //getters
  List<CallRecord>? get callRecordsList => _callRecordsList;

  CallRecord? get callRecord => _callRecord;

  bool get isFetchingData => _isFetchingData;

  String get errorMessage => _errorMessage;

  setErrorMessage(value) {
    _errorMessage = value;
    notifyListeners();
  }

  setFetchingData(value) {
    _isFetchingData = value;
    notifyListeners();
  }

  //setting call records of user
  setCallRecords(value) {
    callRecordsList!.clear();

    var listOfRecords = value['CallRecord'];
    for (int i = 0; i < listOfRecords.length; i++) {
      callRecordsList!.add(CallRecord.fromJson(listOfRecords[i]));
    }
    notifyListeners();
  }

  //setting on going call's record
  setCallRecord(value) {
    _callRecord = CallRecord.fromJson(value['CallRecord']);
    notifyListeners();
  }

  //to fetch call record of ongoing call
  Future<bool> fetchCallRecord(receiverID, callerID) async {
    setFetchingData(true);
    var callRecordData = await api.fetchCallRecord(receiverID, callerID);
    if (callRecordData['success'] == true) {
      print(callRecordData);
      setCallRecord(callRecordData);
      setFetchingData(false);
      return true;
    } else {
      setErrorMessage(callRecordData['message']);
      setFetchingData(false);
      return false;
    }
  }

  //to keep track of calls
  Future<bool> callRecordBeginning(
      receiverID, callerID, status, channel, token) async {
    setFetchingData(true);
    var callRecordData =
        await api.callRecord(receiverID, callerID, status, channel, token);
    if (callRecordData['success'] == true) {
      print(callRecordData);
      setCallRecord(callRecordData);
      setFetchingData(false);
      return true;
    } else {
      setErrorMessage(callRecordData['message']);
      setFetchingData(false);
      return false;
    }
  }

  //called on ending a call
  Future<bool> callRecordEnding(id, date) async {
    setFetchingData(true);
    var callRecordData = await api.callEnd(id, date);
    if (callRecordData['success'] == true) {
      // message = callRecordData['message'];
      setCallRecord(callRecordData);
      setFetchingData(false);
      return true;
    } else {
      setErrorMessage(callRecordData['message']);
      setFetchingData(false);
      return false;
    }
  }

  //to fetch all call records of user
  Future<bool> getCallRecords(userID) async {
    setFetchingData(true);
    var userData = await api.getCallRecords(userID);
    if (userData['success'] == true) {
      setCallRecords(userData);
      setFetchingData(false);
      return true;
    } else {
      setErrorMessage(userData['message']);
      setFetchingData(false);
      return false;
    }
  }
}
