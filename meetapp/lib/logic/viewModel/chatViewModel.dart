import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:meetapp/logic/model/Chat.dart';
import 'package:meetapp/services/webApi.dart';

class ChatViewModel with ChangeNotifier {
  WebApi api = WebApi();

  List<AllChats> _allChats = []; //stores all contacts with whom user has chat
  AllChats? chat; //fetches chat of single contact with app user
  bool _isFetchingData = false;
  String _errorMessage = '';

  final _socketResponse = StreamController<AllChats>.broadcast();

  void addResponse(AllChats? allChat) => _socketResponse.sink.add(allChat!);

  Stream<AllChats> getResponse() => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }

  //getters
  List<AllChats> get allChats => _allChats;

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

  //setting all chats of app user
  setAllChats(value) {
    allChats.clear();

    var listOfChats = value['allChats'];
    if (listOfChats != null)
      for (int i = 0; i < listOfChats.length; i++) {
        allChats.add(AllChats.fromJson(listOfChats[i]));
      }

    notifyListeners();
  }

  //setting chat of app user with single contact
  setChat(value) {
    if (value['recentMessages'] != null) {
      chat = AllChats.fromJson(value['recentMessages']);
    }

    notifyListeners();
  }

  //getting chat of app user with single contact
  Future<bool> getChat(user2ID, senderID) async {
    setFetchingData(true);
    var chatData = await api.getChats(user2ID, senderID);
    if (chatData['success'] == true) {
      setChat(chatData);
      setFetchingData(false);
      return true;
    } else {
      setErrorMessage(chatData['message']);
      setFetchingData(false);
      return false;
    }
  }

  //getting all chats of app user
  Future<bool> getAllChat(userID) async {
    setFetchingData(true);
    var chatData = await api.getAllChats(userID);
    if (chatData['success'] == true) {
      setAllChats(chatData);
      setFetchingData(false);
      return true;
    } else {
      setErrorMessage(chatData['message']);
      setFetchingData(false);
      return false;
    }
  }
}
