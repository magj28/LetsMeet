import 'package:flutter/material.dart';
import 'package:meetapp/logic/model/User.dart';
import 'package:meetapp/services/webApi.dart';

class SearchViewModel with ChangeNotifier {
  WebApi api = WebApi();

  bool _isFetchingData = false;
  String _errorMessage = '';
  List<User> _userList = []; //stores list of users that satisfy search parameter

  //getters
  List<User> get userList => _userList;

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

  //setting users that satisfy search parameter
  setSearchList(value) {
    userList.clear();

    var allUsers = value['users'];
    for (int i = 0; i < allUsers.length; i++) {
      _userList.add(User.fromJson(allUsers[i]));
    }

    notifyListeners();
  }

  //getting users that satisfy search parameter
  Future<bool> getSearchItems(String keyword, id) async {
    setFetchingData(true);
    var productsList = await api.getSuggestions(keyword, id);
    if (productsList['success'] == true) {
      setSearchList(productsList);
      setFetchingData(false);
      return true;
    } else {
      setErrorMessage(productsList['message']);
      setFetchingData(false);
      return false;
    }
  }
}
