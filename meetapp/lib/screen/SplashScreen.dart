import 'dart:async';
import 'package:flutter/material.dart';
import 'package:meetapp/logic/viewModel/callRecordViewModel.dart';
import 'package:meetapp/logic/viewModel/chatViewModel.dart';
import 'package:meetapp/logic/viewModel/userViewModel.dart';
import 'package:meetapp/utils/color_utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  void startTimer() async {
    Timer(Duration(seconds: 3), () {
      navigateUser(); //It will redirect  after 3 seconds
    });
  }

  //checks if user is logged into the app already
  void navigateUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool('isLoggedIn') ?? false;
    if (status) {
      var userID = prefs.getString("userID");

      final user = Provider.of<UserViewModel>(context, listen: false);
      await user.getData(userID);
      await user.allUsers(userID);

      final chat = Provider.of<ChatViewModel>(context, listen: false);
      await chat.getAllChat(userID);

      final callRecord =
          Provider.of<CallRecordViewModel>(context, listen: false);
      await callRecord.getCallRecords(userID);

      var index = prefs.getInt('index');
      if (index == null) {
        prefs.setInt('index', 0);
        index = 0;
      }
      Provider.of<ColorUtils>(context, listen: false).getColorScheme(index);

      Navigator.pushReplacementNamed(context, "/homePage");
    } else {
      Navigator.pushReplacementNamed(context, "/login");
    }
  }
}
