import 'package:flutter/material.dart';
import 'package:meetapp/logic/viewModel/callRecordViewModel.dart';
import 'package:meetapp/logic/viewModel/chatViewModel.dart';
import 'package:meetapp/logic/viewModel/userViewModel.dart';
import 'package:meetapp/screen/CallRecordScreen.dart';
import 'package:meetapp/utils/color_utils.dart';
import 'package:meetapp/utils/dimensions.dart';
import 'package:meetapp/widgets/IconButtonWidget.dart';
import 'package:meetapp/widgets/CircleAvatar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ListTileForDrawer.dart';

//common drawer for all appbars
class CommonDrawer extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserViewModel>(context, listen: false);
    final callRecords =
        Provider.of<CallRecordViewModel>(context, listen: false);
    final chat = Provider.of<ChatViewModel>(context, listen: false);
    String userID = user.user!.userID;

    return Drawer(
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: ColorUtils.color!.primaryColor,
            ),
            accountName: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(user.user!.firstName + " " + user.user!.lastName),
                IconButtonWidget(
                  icon: Icons.edit,
                  onPressed: () {
                    Navigator.pushNamed(context, '/profile');
                  },
                  color: ColorUtils.whiteColor,
                )
              ],
            ),
            accountEmail: Text("@" + user.user!.userName),
            currentAccountPicture: circleAvatar(
                user.user!.firstName, user.user!.lastName, false, spacingLarge),
          ),
          listTileForDrawer(Icon(Icons.brush), "Themes", () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            int? index = prefs.getInt('index');
            print(index);
            Navigator.pushNamed(context, '/themes', arguments: index).then((value) {
              Navigator.pushNamed(context, '/homePage');
            });
          }, true),
          listTileForDrawer(Icon(Icons.person), "Contacts", () async {
            await user.allUsers(userID);
            Navigator.pushNamed(context, '/users');
          }, false),
          listTileForDrawer(Icon(Icons.search), "Search", () async {
            Navigator.pushNamed(context, '/searchPage');
          }, true),
          listTileForDrawer(Icon(Icons.call), "Call Logs", () async {
            await callRecords.getCallRecords(userID);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CallRecordScreen()),
            );
          }, false),
          listTileForDrawer(Icon(Icons.chat), "Chats", () async {
            await chat.getAllChat(userID);
            Navigator.pushNamed(context, '/chatList');
          }, true),
          listTileForDrawer(Icon(Icons.settings), "Sign Out", () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.clear();
            Navigator.pushNamedAndRemoveUntil(context, '/login', ModalRoute.withName('/'));
          }, true),
        ],
      ),
    );
  }
}
