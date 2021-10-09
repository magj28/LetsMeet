import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:meetapp/logic/viewModel/callRecordViewModel.dart';
import 'package:meetapp/screen/CallRecordScreen.dart';
import 'package:meetapp/screen/ConversationPageList.dart';
import 'package:meetapp/screen/UserProfile.dart';
import 'package:meetapp/utils/color_utils.dart';
import 'package:meetapp/utils/socketManager.dart';
import 'package:provider/provider.dart';
import 'Users.dart';
import 'package:meetapp/logic/viewModel/chatViewModel.dart';
import 'package:meetapp/logic/viewModel/userViewModel.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ListQueue<int> _navigationQueue = ListQueue(); //stores stack of pages
  int _selectedIndex = 0;

  @override
  void initState() {
    SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
      initSocketManager(context);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onTabTapped(int index) async {
    if (index != _selectedIndex) {
      _navigationQueue.removeWhere((element) => element == index);
      _navigationQueue.addLast(index);
      setState(() {
        this._selectedIndex = index;
      });
    }
    final user = Provider.of<UserViewModel>(context, listen: false);
    final chat = Provider.of<ChatViewModel>(context, listen: false);
    final callRecord = Provider.of<CallRecordViewModel>(context, listen: false);
    String userID = user.user!.userID;
    if (index == 0) {
      await chat.getAllChat(userID);
    } else if (index == 1) {
      await user.getData(userID);
      await user.allUsers(userID);
    } else if (index == 2) {
      await callRecord.getCallRecords(userID);
    }
  }

  static const snackBarDuration = Duration(seconds: 3);

  final snackBar = SnackBar(
    content: Text('Press back again to exit'),
    duration: snackBarDuration,
  );

  DateTime? backButtonPressTime;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final now = DateTime.now();
        final backButtonHasNotBeenPressedOrSnackBarHasBeenClosed =
            backButtonPressTime == null ||
                now.difference(backButtonPressTime!) > snackBarDuration;

        // below code keeps track of all the navigated indexes
        if (_navigationQueue.isEmpty) {
          if (backButtonHasNotBeenPressedOrSnackBarHasBeenClosed) {
            backButtonPressTime = now;
            ScaffoldMessenger.of(context).showSnackBar(
                snackBar); //if trying to exit app, show snack bar asking to press again to exit
            return false;
          }
          return true;
        }

        setState(() {
          _navigationQueue.removeLast();
          int position = _navigationQueue.isEmpty ? 0 : _navigationQueue.last;
          _selectedIndex = position;
        });
        return false;
      },
      child: Scaffold(
        body: (getBody(_selectedIndex)),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: ColorUtils.color!.bottomNavBar,
          selectedItemColor: ColorUtils.whiteColor,
          unselectedItemColor: ColorUtils.bottomNavBarUnselected,
          currentIndex: this._selectedIndex,
          onTap: onTabTapped,
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.chat_bubble),
              title: new Text('Chats'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.supervisor_account_sharp),
              title: new Text('Contacts'),
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.call),
              title: new Text('Logs'),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), title: Text('Profile'))
          ],
        ),
      ),
    );
  }

  Widget getBody(int index) {
    switch (index) {
      case 0:
        return ConversationPageList();
      case 1:
        return Users();
      case 2:
        return CallRecordScreen();
      case 3:
        return ProfilePage();
    }
    return Container();
  }
}
