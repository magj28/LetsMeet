import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:meetapp/utils/constants/api_constants.dart';

class WebApi {
  final String url = ApiConstants.url + "/";
  var networkError = {
    'success': false,
    'error': "Network Error.",
    'message':
        "Some kind of network error occurred. Cannot send requests. Check your network and if the problem persists then probably the server isn't responding."
  };

  Future<dynamic> login(username, password) async {
    final apiUrl = url + 'user/login';
    var response, responseStatus;
    try {
      response = await http.post(Uri.parse(apiUrl),
          body: {'username': username, 'password': password});
      responseStatus = json.decode(response.body)['status'];
    } catch (e) {
      return networkError;
    }
    if (response.statusCode == 200 && responseStatus == "success") {
      var userData = {
        'success': true,
        'message': json.decode(response.body)['message'],
        'user': json.decode(response.body)['data']['User'],
      };
      return userData;
    } else {
      var error = {
        'success': false,
        'error': json.decode(response.body)['error'],
        'message': json.decode(response.body)['message']
      };
      return error;
    }
  }

  Future<dynamic> getData(userID) async {
    final apiUrl = url + 'user/getUserData/$userID';
    var response, responseStatus;
    try {
      response = await http.get(Uri.parse(apiUrl));
      responseStatus = json.decode(response.body)['status'];
    } catch (e) {
      return networkError;
    }
    if (response.statusCode == 200 && responseStatus == "success") {
      var userData = {
        'success': true,
        'message': json.decode(response.body)['message'],
        'user': json.decode(response.body)['data']['User'],
      };
      return userData;
    } else {
      var error = {
        'success': false,
        'error': json.decode(response.body)['error'],
        'message': json.decode(response.body)['message']
      };
      return error;
    }
  }

  Future<dynamic> checkUserNameUnique(username) async {
    final apiUrl = url + 'user/usernameCheck/$username';
    var response, responseStatus;
    try {
      response = await http.get(Uri.parse(apiUrl));
      responseStatus = json.decode(response.body)['status'];
    } catch (e) {
      return networkError;
    }
    if (response.statusCode == 200 && responseStatus == "success") {
      var userData = {
        'success': true,
        'message': json.decode(response.body)['message']
      };
      return userData;
    } else {
      var error = {
        'success': false,
        'error': json.decode(response.body)['error'],
        'message': json.decode(response.body)['message']
      };
      return error;
    }
  }

  Future<dynamic> checkEmailUnique(email) async {
    final apiUrl = url + 'user/emailCheck/$email';
    var response, responseStatus;
    try {
      response = await http.get(Uri.parse(apiUrl));
      responseStatus = json.decode(response.body)['status'];
    } catch (e) {
      return networkError;
    }
    if (response.statusCode == 200 && responseStatus == "success") {
      var userData = {
        'success': true,
        'message': json.decode(response.body)['message']
      };
      return userData;
    } else {
      var error = {
        'success': false,
        'error': json.decode(response.body)['error'],
        'message': json.decode(response.body)['message']
      };
      return error;
    }
  }

  Future<dynamic> signUp(firstName, lastName, username, password, email) async {
    final apiUrl = url + 'user/signUp';
    var response, responseStatus;
    try {
      response = await http.post(Uri.parse(apiUrl), body: {
        'firstname': firstName,
        'lastname': lastName,
        'username': username,
        'password': password,
        'email': email
      });
      responseStatus = json.decode(response.body)['status'];
    } catch (e) {
      return networkError;
    }
    if (response.statusCode == 200 && responseStatus == "success") {
      var userData = {
        'success': true,
        'user': json.decode(response.body)['data']['User'],
        'message': json.decode(response.body)['message']
      };
      return userData;
    } else {
      var error = {
        'success': false,
        'error': json.decode(response.body)['error'],
        'message': json.decode(response.body)['message']
      };
      return error;
    }
  }

  Future<dynamic> findName(id) async {
    final apiUrl = url + 'user/findName/$id';
    var response, responseStatus;
    try {
      response = await http.get(Uri.parse(apiUrl));
      responseStatus = json.decode(response.body)['status'];
    } catch (e) {
      return networkError;
    }
    if (response.statusCode == 200 && responseStatus == "success") {
      var userData = {
        'success': true,
        'firstname': json.decode(response.body)['firstname'],
        'lastname': json.decode(response.body)['lastname'],
        'message': json.decode(response.body)['message']
      };
      return userData;
    } else {
      var error = {
        'success': false,
        'error': json.decode(response.body)['error'],
        'message': json.decode(response.body)['message']
      };
      return error;
    }
  }

  Future<dynamic> allUsers(id) async {
    final apiUrl = url + 'user/getAllUsers/$id';
    var response, responseStatus;
    try {
      response = await http.get(Uri.parse(apiUrl));
      responseStatus = json.decode(response.body)['status'];
    } catch (e) {
      return networkError;
    }
    if (response.statusCode == 200 && responseStatus == "success") {
      var userData = {
        'success': true,
        'users': json.decode(response.body)['users'],
        'message': json.decode(response.body)['message']
      };
      return userData;
    } else {
      var error = {
        'success': false,
        'error': json.decode(response.body)['error'],
        'message': json.decode(response.body)['message']
      };
      return error;
    }
  }

  Future<dynamic> editDetails(userID, firstName, lastName) async {
    final apiUrl = url + 'user/edit/$userID';
    var response, responseStatus;
    try {
      response = await http.post(Uri.parse(apiUrl),
          body: {'firstName': firstName, 'lastName': lastName});
      responseStatus = json.decode(response.body)['status'];
    } catch (e) {
      return networkError;
    }
    if (response.statusCode == 200 && responseStatus == "success") {
      var userData = {
        'success': true,
        'user': json.decode(response.body)['User'],
        'message': json.decode(response.body)['message']
      };
      return userData;
    } else {
      var error = {
        'success': false,
        'error': json.decode(response.body)['error'],
        'message': json.decode(response.body)['message']
      };
      return error;
    }
  }

  Future<dynamic> getSuggestions(String keyword, id) async {
    final apiUrl = url + 'search/$keyword/$id';
    var response, responseStatus;
    try {
      response = await http.get(Uri.parse(apiUrl));
      responseStatus = json.decode(response.body)['status'];
    } catch (e) {
      return networkError;
    }
    if (response.statusCode == 200 && responseStatus == "success") {
      var searchData = {
        'success': true,
        "users": json.decode(response.body)["users"],
        'message': json.decode(response.body)['message']
      };
      return searchData;
    } else {
      var error = {
        'success': false,
        'error': json.decode(response.body)['error'],
        'message': json.decode(response.body)['message']
      };
      return error;
    }
  }

  Future<dynamic> getChats(user2ID, senderID) async {
    final apiUrl = url + 'chat/getChats';
    var response, responseStatus;
    try {
      response = await http.post(Uri.parse(apiUrl), body: {
        "user1ID": senderID, //Receiver Id
        "user2ID": user2ID,
      });
      responseStatus = json.decode(response.body)['status'];
    } catch (e) {
      return networkError;
    }
    if (response.statusCode == 200 && responseStatus == "success") {
      var userData = {
        'success': true,
        'recentMessages': json.decode(response.body)['recentMessages'],
        'message': json.decode(response.body)['message']
      };
      return userData;
    } else {
      var error = {
        'success': false,
        'error': json.decode(response.body)['error'],
        'message': json.decode(response.body)['message']
      };
      return error;
    }
  }

  Future<dynamic> getAllChats(userID) async {
    final apiUrl = url + 'chat/all/$userID';
    var response, responseStatus;
    try {
      response = await http.get(Uri.parse(apiUrl));
      responseStatus = json.decode(response.body)['status'];
    } catch (e) {
      return networkError;
    }
    if (response.statusCode == 200 && responseStatus == "success") {
      var chatData = {
        'success': true,
        "allChats": json.decode(response.body)["allChats"],
        'message': json.decode(response.body)['message']
      };
      return chatData;
    } else {
      var error = {
        'success': false,
        'error': json.decode(response.body)['error'],
        'message': json.decode(response.body)['message']
      };
      return error;
    }
  }

  Future<dynamic> fetchCallRecord(receiverID, callerID) async {
    final apiUrl = url + 'callRecord/single';
    var response, responseStatus;
    try {
      response = await http.post(Uri.parse(apiUrl), body: {
        'receiverID': receiverID,
        'callerID': callerID,
      });
      responseStatus = json.decode(response.body)['status'];
    } catch (e) {
      return networkError;
    }
    if (response.statusCode == 200 && responseStatus == "success") {
      var userData = {
        'success': true,
        'CallRecord': json.decode(response.body)['data']['CallRecord'],
        'message': json.decode(response.body)['message']
      };
      return userData;
    } else {
      var error = {
        'success': false,
        'error': json.decode(response.body)['error'],
        'message': json.decode(response.body)['message']
      };
      return error;
    }
  }

  Future<dynamic> callRecord(
      receiverID, callerID, status, channel, token) async {
    final apiUrl = url + 'callRecord/new';
    var response, responseStatus;
    try {
      response = await http.post(Uri.parse(apiUrl), body: {
        'receiverID': receiverID,
        'callerID': callerID,
        'status': status,
        'channel': channel,
        'token': token,
      });
      responseStatus = json.decode(response.body)['status'];
    } catch (e) {
      return networkError;
    }
    if (response.statusCode == 200 && responseStatus == "success") {
      var userData = {
        'success': true,
        'CallRecord': json.decode(response.body)['data']['CallRecord'],
        'message': json.decode(response.body)['message']
      };
      return userData;
    } else {
      var error = {
        'success': false,
        'error': json.decode(response.body)['error'],
        'message': json.decode(response.body)['message']
      };
      return error;
    }
  }

  Future<dynamic> callEnd(id, date) async {
    final apiUrl = url + 'callRecord/end';
    var response, responseStatus;
    try {
      response =
          await http.post(Uri.parse(apiUrl), body: {'id': id, 'date': date});
      responseStatus = json.decode(response.body)['status'];
    } catch (e) {
      return networkError;
    }
    if (response.statusCode == 200 && responseStatus == "success") {
      var userData = {
        'success': true,
        'CallRecord': json.decode(response.body)['data']['CallRecord'],
        'message': json.decode(response.body)['message']
      };
      return userData;
    } else {
      var error = {
        'success': false,
        'error': json.decode(response.body)['error'],
        'message': json.decode(response.body)['message']
      };
      return error;
    }
  }

  Future<dynamic> getCallRecords(userID) async {
    final apiUrl = url + 'callRecord/getCallRecords/$userID';
    var response, responseStatus;
    try {
      response = await http.get(Uri.parse(apiUrl));
      responseStatus = json.decode(response.body)['status'];
    } catch (e) {
      return networkError;
    }
    if (response.statusCode == 200 && responseStatus == "success") {
      var callRecordData = {
        'success': true,
        "CallRecord": json.decode(response.body)['data']['CallRecord'],
        'message': json.decode(response.body)['message']
      };
      return callRecordData;
    } else {
      var error = {
        'success': false,
        'error': json.decode(response.body)['error'],
        'message': json.decode(response.body)['message']
      };
      return error;
    }
  }
}
