import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meetapp/logic/model/Chat.dart';
import 'package:meetapp/logic/model/res_call_accept_model.dart';
import 'package:meetapp/logic/model/res_call_request_model.dart';
import 'package:meetapp/logic/viewModel/chatViewModel.dart';
import 'package:meetapp/logic/viewModel/userViewModel.dart';
import 'package:meetapp/utils/color_utils.dart';
import 'package:meetapp/utils/constants/arg_constants.dart';
import 'package:meetapp/utils/constants/route_constants.dart';
import 'package:meetapp/utils/constants/socketConstants.dart';
import 'package:meetapp/utils/navigation_utils.dart';
import 'package:meetapp/utils/permission_utils.dart';
import 'package:meetapp/utils/socketManager.dart';
import 'package:meetapp/widgets/ChatItemWidget.dart';
import 'package:meetapp/widgets/CommonAppBar.dart';
import 'package:meetapp/widgets/InputWidget.dart';
import 'package:meetapp/widgets/CircProgressIndicator.dart';
import 'package:meetapp/widgets/IconButtonWidget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class ConversationPage extends StatefulWidget {
  AllChats? allChats;
  String? origin;

  ConversationPage({this.allChats, this.origin});

  @override
  _ConversationPageState createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  final ScrollController listScrollController = new ScrollController();
  final ScrollController listScrollController2 = new ScrollController();

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      if (listScrollController.hasClients)
        listScrollController
            .jumpTo(listScrollController.position.maxScrollExtent);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserViewModel>(context, listen: false);
    final chat = Provider.of<ChatViewModel>(context, listen: false);

    String userID = user.user!.userID;
    String? otherUserID = (userID == widget.allChats!.user1ID)
        ? widget.allChats!.user2ID
        : widget.allChats!.user1ID;

    return WillPopScope(
        onWillPop: () async {
          emit(
              SocketConstants.disconnectMessage,
              ({
                "userID": userID,
              }));
          return true;
        },
        child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: CommonAppBar(
              title: user.firstName + " " + user.lastName,
              leading: IconButtonWidget(
                icon: Icons.arrow_back,
                onPressed: () {
                  emit(
                      SocketConstants.disconnectMessage,
                      ({
                        "userID": userID,
                      }));
                  Navigator.pop(context);
                },
                color: ColorUtils.whiteColor,
              ),
              action: [
                widget.origin == 'vc'
                    ? Container() //if opening chat from video call, do not show icon in app bar
                    : IconButtonWidget(
                        icon: Icons.video_call,
                        color: ColorUtils.whiteColor,
                        onPressed: () {
                          PermissionUtils.requestPermission([
                            PermissionGroup.camera,
                            PermissionGroup.microphone
                          ], context, isOpenSettings: true,
                              permissionGrant: () async {
                            emit(
                                SocketConstants.connectCall,
                                ({
                                  ArgParams.connectId:
                                      otherUserID, //Receiver Id
                                }));

                            NavigationUtils.push(
                                context, RouteConstants.routePickUpScreen,
                                arguments: {
                                  ArgParams.resCallAcceptModel:
                                      ResCallAcceptModel(
                                          otherUserId: otherUserID),
                                  //Receiver Id
                                  ArgParams.resCallRequestModel:
                                      ResCallRequestModel(),
                                  ArgParams.isForOutGoing: true,
                                  ArgParams.firstName: user.firstName,
                                  ArgParams.lastName: user.lastName
                                });
                          });
                        },
                      )
              ],
            ),
            body: Provider.of<ChatViewModel>(context)
                    .isFetchingData //shows circular progress indicator till data loads
                ? CircProgressIndicator()
                : SingleChildScrollView(
                        controller: listScrollController,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            StreamBuilder<AllChats>(
                              stream: chat.getResponse(),
                                //stream listens to update in chat and shows in page
                                initialData: chat.chat,
                              builder: (context, AsyncSnapshot<AllChats> snapshot) {
                                List<Chat>? chatStream = snapshot.data!.chats;
                                return chatStream!.length == 0
                                    ? Container(
                                        height: MediaQuery.of(context).size.height)
                                    : Container(
                                        height: MediaQuery.of(context).size.height,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          padding: EdgeInsets.all(10.0),
                                          itemBuilder: (context, index) {
                                            return ChatItemWidget(chatStream[
                                                chatStream.length - index - 1]);
                                          },
                                          itemCount: chatStream.length,
                                          reverse: true,
                                          controller: listScrollController2,
                                        ),
                                      );
                              }
                            ),
                            InputWidget(userID, otherUserID),
                          ],
                        ),
                      )
                    ));
  }
}
