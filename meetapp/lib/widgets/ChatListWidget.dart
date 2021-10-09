import 'package:flutter/material.dart';
import 'package:meetapp/logic/model/Chat.dart';
import 'ChatItemWidget.dart';

//builds entire chat
class ChatListWidget extends StatelessWidget {
  final ScrollController listScrollController = new ScrollController();

  List<Chat>? chats;

  ChatListWidget(this.chats);

  @override
  Widget build(BuildContext context) {
    return chats!.length == 0
        ? Center(
            child: Container(child: Text("Start Chatting")),
          )
        : Expanded(
            child: SingleChildScrollView(
                child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) =>
                  ChatItemWidget(chats![chats!.length - index - 1]),
              itemCount: chats!.length,
              reverse: true,
              controller: listScrollController,
            )),
          );
  }
}
