import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meetapp/logic/viewModel/chatViewModel.dart';
import 'package:meetapp/logic/viewModel/userViewModel.dart';
import 'package:meetapp/utils/color_utils.dart';
import 'package:meetapp/widgets/CommonAppBar.dart';
import 'package:meetapp/widgets/CommonDrawer.dart';
import 'package:meetapp/widgets/ConversationPageListTile.dart';
import 'package:meetapp/widgets/IconButtonWidget.dart';
import 'package:provider/provider.dart';

class ConversationPageList extends StatefulWidget {
  @override
  _ConversationPageListState createState() => _ConversationPageListState();
}

class _ConversationPageListState extends State<ConversationPageList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final chat = Provider.of<ChatViewModel>(context, listen: false);
    final user = Provider.of<UserViewModel>(context, listen: false);

    return chat.allChats.length == 0
        ? Scaffold(
            appBar: CommonAppBar(title:"Chats", action: [],),
            drawer: CommonDrawer(),
            body: Center(
              child: Container(
                height: MediaQuery.of(context).size.height / 10,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(ColorUtils.listTileArrow),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/users').then((_) async {
                      await chat.getAllChat(user.user!.userID);
                      setState(() {});
                    });
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color: ColorUtils.blackColor,
                      ),
                      Text(
                        "Start a new chat",
                        style: TextStyle(color: ColorUtils.blackColor),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        : Scaffold(
            appBar: CommonAppBar(
              title: "Chats",
              action: [
                IconButtonWidget(
                  onPressed: () {
                    Navigator.pushNamed(context, '/users').then((_) async {
                      await chat.getAllChat(user.user!.userID);
                      setState(() {});
                    });
                  },
                  icon: Icons.add,
                  color: ColorUtils.whiteColor,
                )
              ],
            ),
            drawer: CommonDrawer(),
            body: SingleChildScrollView(
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: chat.allChats.length,
                itemBuilder: (context, index) {
                  String? userID =
                      user.user!.userID == chat.allChats[index].user1ID
                          ? chat.allChats[index].user2ID
                          : chat.allChats[index].user1ID;
                  String? firstName;
                  String? lastName;
                  String? userName;
                  user.userList.forEach((individualUser) {
                    if (individualUser.userID == userID) {
                      firstName = individualUser.firstName;
                      lastName = individualUser.lastName;
                      userName = individualUser.userName;
                    }
                  });
                  return ConversationPageListTile(
                      index,
                      firstName,
                      lastName,
                      userName,
                      userID,
                      chat.allChats[index]);
                },
              ),
            ));
  }
}
