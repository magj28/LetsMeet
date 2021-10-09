import 'package:flutter/material.dart';
import 'package:meetapp/logic/model/res_call_accept_model.dart';
import 'package:meetapp/logic/model/res_call_request_model.dart';
import 'package:meetapp/logic/viewModel/chatViewModel.dart';
import 'package:meetapp/logic/viewModel/userViewModel.dart';
import 'package:meetapp/utils/color_utils.dart';
import 'package:meetapp/utils/constants/arg_constants.dart';
import 'package:meetapp/utils/constants/route_constants.dart';
import 'package:meetapp/utils/constants/socketConstants.dart';
import 'package:meetapp/utils/dimensions.dart';
import 'package:meetapp/utils/navigation_utils.dart';
import 'package:meetapp/utils/permission_utils.dart';
import 'package:meetapp/utils/socketManager.dart';
import 'package:meetapp/widgets/IconButtonWidget.dart';
import 'package:meetapp/widgets/CircleAvatar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

//container displaying user information
class UserListTile extends StatelessWidget {
  String? token;
  String? channel;
  String userName;
  String firstName;
  String lastName;
  String userID;

  UserListTile(String? token, String? channel, String userName,
      String firstName, String lastName, String userID)
      : token = token,
        channel = channel,
        userName = userName,
        firstName = firstName,
        lastName = lastName,
        userID = userID;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserViewModel>(context, listen: false);
    final chat = Provider.of<ChatViewModel>(context, listen: false);
    return Column(
      children: [
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        circleAvatar(firstName, lastName, true, spacingLarge),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(firstName + " " + lastName),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "@" + userName,
                            style: TextStyle(color: ColorUtils.greyColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButtonWidget(
                      color: ColorUtils.color!.bottomNavBar,
                      onPressed: () async {
                        print("Chat Clicked");

                        String senderID = user.user!.userID;

                        emit(
                            SocketConstants.connectMessage,
                            ({
                              "otherUserId": userID,
                            }));

                        await chat.getChat(userID, senderID);
                        await user.findName(userID);
                        Navigator.pushNamed(
                            buildContext!, RouteConstants.routeMessage,
                            arguments: {"allChats": chat.chat, "origin":"conversationListTile"});
                      },
                      icon: Icons.chat),
                  IconButtonWidget(
                      color: ColorUtils.color!.bottomNavBar,
                      onPressed: () {
                        PermissionUtils.requestPermission([
                          PermissionGroup.camera,
                          PermissionGroup.microphone
                        ], context, isOpenSettings: true,
                            permissionGrant: () async {
                          if (token != null && channel != null) {
                            emit(
                                SocketConstants.connectCall,
                                ({
                                  ArgParams.connectId: userID, //Receiver Id
                                  ArgParams.channelKey: channel,
                                  ArgParams.channelTokenKey: token,
                                }));
                            NavigationUtils.push(
                                context, RouteConstants.routePickUpScreen,
                                arguments: {
                                  ArgParams.resCallAcceptModel:
                                      ResCallAcceptModel(otherUserId: userID),
                                  //Receiver Id
                                  ArgParams.resCallRequestModel:
                                      ResCallRequestModel(),
                                  ArgParams.isForOutGoing: true,
                                  ArgParams.firstName: firstName,
                                  ArgParams.lastName: lastName
                                });
                          } else {
                            emit(
                                SocketConstants.connectCall,
                                ({
                                  ArgParams.connectId: userID, //Receiver Id
                                }));
                            NavigationUtils.push(
                                context, RouteConstants.routePickUpScreen,
                                arguments: {
                                  ArgParams.resCallAcceptModel:
                                      ResCallAcceptModel(otherUserId: userID),
                                  //Receiver Id
                                  ArgParams.resCallRequestModel:
                                      ResCallRequestModel(),
                                  ArgParams.isForOutGoing: true,
                                  ArgParams.firstName: firstName,
                                  ArgParams.lastName: lastName
                                });
                          }
                        });
                      },
                      icon: Icons.video_call),
                ],
              )
            ],
          ),
        ),
        Divider(
          color: ColorUtils.greyColor,
        )
      ],
    );
  }
}
