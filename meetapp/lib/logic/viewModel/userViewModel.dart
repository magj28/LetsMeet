import 'package:flutter/cupertino.dart';
import 'package:meetapp/logic/model/User.dart';
import 'package:meetapp/services/webApi.dart';

class UserViewModel with ChangeNotifier {
  WebApi api = WebApi();

  User? user; //stores details of app user
  List<User> userList = []; //stores details of all users present on app
  bool _isFetchingData = false;
  String _errorMessage = '';
  String message = '';
  String firstName = ''; //stores first name of user clicked on
  String lastName = ''; //stores last name of user clicked on

  //getters
  //User get user => _user;

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

  //setting all users that have an account on the app
  setAllUsers(value) {
    userList.clear();

    var listOfUser = value['users'];
    for (int i = 0; i < listOfUser.length; i++) {
      userList.add(User.fromJson(listOfUser[i]));
    }

    notifyListeners();
  }

  //setting details of app user
  setUser(value) {
    user = User.fromJson(value['user']);
    notifyListeners();
  }

  //login function
  Future<bool> login(username, password) async {
    setFetchingData(true);
    var userData = await api.login(username, password);
    if (userData['success'] == true) {
      message = userData['message'];
      if (message == 'User login') setUser(userData);
      setFetchingData(false);
      return true;
    } else {
      setErrorMessage(userData['message']);
      setFetchingData(false);
      return false;
    }
  }

  //getting user details
  Future<bool> getData(userID) async {
    setFetchingData(true);
    var userData = await api.getData(userID);
    if (userData['success'] == true) {
      setUser(userData);
      setFetchingData(false);
      return true;
    } else {
      setErrorMessage(userData['message']);
      setFetchingData(false);
      return false;
    }
  }

  //checking if username is unique
  Future<bool> checkUserNameUnique(username) async {
    setFetchingData(true);
    var userData = await api.checkUserNameUnique(username);
    if (userData['success'] == true) {
      message = userData['message'];
      setFetchingData(false);
      return true;
    } else {
      setErrorMessage(userData['message']);
      setFetchingData(false);
      return false;
    }
  }

  //checking if email is unique
  Future<bool> checkEmailUnique(email) async {
    setFetchingData(true);
    var userData = await api.checkEmailUnique(email);
    if (userData['success'] == true) {
      message = userData['message'];
      setFetchingData(false);
      return true;
    } else {
      setErrorMessage(userData['message']);
      setFetchingData(false);
      return false;
    }
  }

  //sign up of new user
  Future<bool> signUp(firstName, lastName, username, password, email) async {
    setFetchingData(true);
    var userData = await api.signUp(firstName, lastName, username, password, email);
    if (userData['success'] == true) {
      setUser(userData);
      setFetchingData(false);
      return true;
    } else {
      setErrorMessage(userData['message']);
      setFetchingData(false);
      return false;
    }
  }

  //finding first and last name of user clicked on
  Future<bool> findName(id) async {
    setFetchingData(true);
    var userData = await api.findName(id);
    if (userData['success'] == true) {
      firstName = userData['firstname'];
      lastName = userData['lastname'];
      setFetchingData(false);
      return true;
    } else {
      setErrorMessage(userData['message']);
      setFetchingData(false);
      return false;
    }
  }

  //fetching all users
  Future<bool> allUsers(id) async {
    setFetchingData(true);
    var userData = await api.allUsers(id);
    if (userData['success'] == true) {
      setAllUsers(userData);
      setFetchingData(false);
      return true;
    } else {
      setErrorMessage(userData['message']);
      setFetchingData(false);
      return false;
    }
  }

  //to edit details in user profile
  Future<bool> editDetails(userID, firstName, lastName) async {
    setFetchingData(true);
    var sellerData = await api.editDetails(userID, firstName, lastName);
    if (sellerData['success'] == true) {
      setUser(sellerData);
      setFetchingData(false);
      return true;
    } else {
      setErrorMessage(sellerData['message']);
      setFetchingData(false);
      return false;
    }
  }
}
