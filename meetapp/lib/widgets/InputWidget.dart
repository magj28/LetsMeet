import 'package:flutter/material.dart';
import 'package:meetapp/utils/color_utils.dart';
import 'package:meetapp/utils/constants/socketConstants.dart';
import 'package:meetapp/utils/socketManager.dart';

//input widget at the bottom of the chat page
class InputWidget extends StatelessWidget {
  String? userID;
  String? user2ID;

  InputWidget(this.userID, this.user2ID);

  final TextEditingController textEditingController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Row(
        children: <Widget>[
          // Text input
          Flexible(
            child: Container(
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                textInputAction: TextInputAction.newline,
                style: TextStyle(color: ColorUtils.blackColor),
                controller: textEditingController,
                decoration: InputDecoration(
                  contentPadding: // Text Field height
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  hintText: 'Type a message',
                  hintStyle: TextStyle(color: ColorUtils.greyColor),
                ),
              ),
            ),
          ),

          // Send Message Button
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () async {
                  emit(
                      SocketConstants.message,
                      ({
                        'user1ID': userID,
                        'user2ID': user2ID,
                        'senderID': userID,
                        'message': textEditingController.text,
                      }));

                  textEditingController.text = '';
                },
                color: ColorUtils.greyColor,
              ),
            ),
            color: ColorUtils.whiteColor,
          ),
        ],
      ),
    );
  }
}
