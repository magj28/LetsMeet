import 'package:flutter/material.dart';
import 'package:meetapp/logic/model/Chat.dart';
import 'package:meetapp/logic/viewModel/chatViewModel.dart';
import 'package:meetapp/logic/viewModel/userViewModel.dart';
import 'package:meetapp/utils/color_utils.dart';
import 'package:meetapp/utils/constants/route_constants.dart';
import 'package:meetapp/utils/constants/socketConstants.dart';
import 'package:meetapp/utils/dimensions.dart';
import 'package:meetapp/utils/navigation_utils.dart';
import 'package:meetapp/utils/socketManager.dart';
import 'package:meetapp/widgets/CircleAvatar.dart';
import 'package:provider/provider.dart';

//builds all conversations' page
class ConversationPageListTile extends StatelessWidget {
  int? index;
  String? firstName;
  String? lastName;
  String? userName;
  String? userID;
  AllChats? chat;

  ConversationPageListTile(this.index, this.firstName, this.lastName,
      this.userName, this.userID, this.chat);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserViewModel>(context, listen: false);
    final chats = Provider.of<ChatViewModel>(context, listen: false);
    return GestureDetector(
      onTap: () async {
        user.firstName = firstName!;
        user.lastName = lastName!;
        emit(
            SocketConstants.connectMessage,
            ({
              "otherUserId": userID,
            }));

        await chats.getChat(userID, user.user!.userID);
        Navigator.pushNamed(context, RouteConstants.routeMessage,
            arguments: {"allChats": chats.chat, "origin":"conversationListTile"});
      },
      child: Container(
        child: Column(
          children: [
            ListTile(
              trailing: IconButton(
                icon: Icon(Icons.arrow_forward_ios),
                onPressed: () {
                  NavigationUtils.push(context, RouteConstants.routeMessage,
                      arguments: {"allChats": chat, "origin":"conversationListTile"});
                },
              ),
              title: Text(firstName! + " " + lastName!),
              subtitle: Text("@" + userName!),
              leading: circleAvatar(firstName!, lastName!, true, spacingMedium),
            ),
            Divider(
              color: ColorUtils.greyColor,
            )
          ],
        ),
      ),
    );
  }
}
