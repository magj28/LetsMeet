import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meetapp/logic/model/Chat.dart';
import 'package:meetapp/logic/viewModel/userViewModel.dart';
import 'package:meetapp/utils/color_utils.dart';
import 'package:provider/provider.dart';

//Container for each chat (chat bubble+chat time)
class ChatItemWidget extends StatelessWidget {
  Chat chat;

  ChatItemWidget(this.chat);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserViewModel>(context, listen: false);
    if (chat.senderID == user.user!.userID) {
      return Container(
          child: Column(children: <Widget>[
        Row(
          children: <Widget>[
            ChatBubbleWidget(chat.message, false)
          ],
          mainAxisAlignment:
              MainAxisAlignment.end, // aligns the chatitem to right end
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[ChatTimeWidget(chat.date, true)])
      ]));
    } else {
      // This is a received message
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                ChatBubbleWidget(chat.message, true)
              ],
            ),
            ChatTimeWidget(chat.date, true)
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }
}

//displays time in the bottom of each chat container
class ChatTimeWidget extends StatelessWidget {
  String date;
  bool receiver;

  ChatTimeWidget(this.date, this.receiver);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        DateFormat('dd MMM kk:mm').format(DateTime.fromMillisecondsSinceEpoch(
            DateTime.parse(date).millisecondsSinceEpoch)),
        style: TextStyle(
            color: ColorUtils.greyColor,
            fontSize: 12.0,
            fontStyle: FontStyle.normal),
      ),
      margin: receiver
          ? EdgeInsets.only(right: 5.0, top: 5.0, bottom: 5.0)
          : EdgeInsets.only(left: 5.0, top: 5.0, bottom: 5.0),
    );
  }
}

//chat bubble
class ChatBubbleWidget extends StatelessWidget {
  String message;
  bool receiver;

  ChatBubbleWidget(this.message, this.receiver);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        message,
        style: TextStyle(color: receiver?ColorUtils.blackColor:ColorUtils.whiteColor),
      ),
      padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
      width: MediaQuery.of(context).size.width / 2,
      decoration: BoxDecoration(
          color: receiver?ColorUtils.receiverChat:ColorUtils.color!.senderChat,
          borderRadius: BorderRadius.circular(8.0)),
      margin: receiver?EdgeInsets.only(left: 10.0):EdgeInsets.only(right: 10.0),
    );
  }
}
