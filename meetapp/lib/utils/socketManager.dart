import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:meetapp/logic/model/Chat.dart';
import 'package:meetapp/logic/viewModel/chatViewModel.dart';
import 'package:meetapp/logic/viewModel/userViewModel.dart';
import 'package:meetapp/screen/VideoCallScreen.dart';
import 'package:meetapp/utils/console_log_utils.dart';
import 'package:meetapp/utils/constants/api_constants.dart';
import 'package:meetapp/utils/constants/arg_constants.dart';
import 'package:meetapp/utils/constants/route_constants.dart';
import 'package:meetapp/utils/navigation_utils.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import 'package:meetapp/logic/model/res_call_accept_model.dart';
import 'package:meetapp/logic/model/res_call_request_model.dart';
import 'package:meetapp/utils/constants/socketConstants.dart';

io.Socket? _socketInstance;
BuildContext? buildContext;
String? channelName;
String? channelToken;
ResCallAcceptModel? resCallAcceptModel;

//Initialize Socket Connection
dynamic initSocketManager(BuildContext context) {
  final user = Provider.of<UserViewModel>(context, listen: false);
  buildContext = context;
  if (_socketInstance != null) return;
  _socketInstance = io.io(
    "${ApiConstants.socketUrl}" + user.user!.userID,
    <String, dynamic>{
      ApiConstants.transportsHeader: [
        ApiConstants.webSocketOption,
        ApiConstants.pollingOption
      ],
    },
  );

  _socketInstance!.connect();

  socketGlobalListeners();
}

//Socket Global Listener Events
dynamic socketGlobalListeners() {
  _socketInstance?.on(SocketConstants.eventConnect, onConnect);
  _socketInstance?.on(SocketConstants.eventDisconnect, onDisconnect);
  _socketInstance?.on(SocketConstants.onSocketError, onConnectError);
  _socketInstance?.on(SocketConstants.eventConnectTimeout, onConnectError);
  _socketInstance?.on(SocketConstants.onCallRequest, handleOnCallRequest);
  _socketInstance?.on(SocketConstants.onAcceptCall, handleOnAcceptCall);
  _socketInstance?.on(SocketConstants.onRejectCall, handleOnRejectCall);
  _socketInstance?.on(SocketConstants.onMessage, handleOnMessage);
  _socketInstance?.on(SocketConstants.onConnectMessage, handleOnConnect);
  _socketInstance?.on(SocketConstants.onDisconnectMessage, handleOnDisconnect);
}

//To Emit Event Into Socket
bool? emit(String event, Map<String, dynamic> data) {
  ConsoleLogUtils.printLog("===> emit $event");
  ConsoleLogUtils.printLog("===> emit $data");
  _socketInstance?.emit(event, jsonDecode(json.encode(data)));
  return _socketInstance?.connected;
}

//Get This Event After Successful Connection To Socket
dynamic onConnect(_) {
  ConsoleLogUtils.printLog("===> connected socket....................");
}

//Get This Event After Connection Lost To Socket Due To Network Or Any Other Reason
dynamic onDisconnect(_) {
  ConsoleLogUtils.printLog("===> Disconnected socket....................");
}

//Get This Event After Connection Error To Socket With Error
dynamic onConnectError(error) {
  ConsoleLogUtils.printLog(
      "===> ConnectError socket.................... $error");
}

//Get This Event When Someone Received Call From Other User
void handleOnCallRequest(dynamic response) {
  if (response != null) {
    final data = ResCallRequestModel.fromJson(response);

    NavigationUtils.push(buildContext!, RouteConstants.routePickUpScreen,
        arguments: {
          ArgParams.resCallAcceptModel: ResCallAcceptModel(),
          ArgParams.resCallRequestModel: data,
          ArgParams.isForOutGoing: false,
          ArgParams.firstName: data.firstName,
          ArgParams.lastName: data.lastName
        });
  }
}

//Get This Event When Other User Accepts Your Call
void handleOnAcceptCall(dynamic response) async {
  if (response != null) {
    final data = ResCallAcceptModel.fromJson(response);
    resCallAcceptModel = data;
    channelName = data.channel;
    channelToken = data.token;
    NavigationUtils.pushReplacement(
        buildContext!, RouteConstants.routeVideoCall,
        arguments: {
          ArgParams.channelKey: data.channel,
          ArgParams.channelTokenKey: data.token,
          ArgParams.resCallAcceptModel: data,
          ArgParams.resCallRequestModel: ResCallRequestModel(),
          ArgParams.isForOutGoing: true,
          ArgParams.userID: data.id
        });
  }
}

//Get This Event When Someone Rejects Call
void handleOnRejectCall(dynamic response) {
  NavigationUtils.pushAndRemoveUntil(
    buildContext!,
    RouteConstants.routeCommon,
  );
}

//Get This Event When Someone sends a message
void handleOnMessage(dynamic response) {
  if (response != null) {
    final data = AllChats.fromJson(response);
    final chat = Provider.of<ChatViewModel>(buildContext!, listen: false);
    chat.chat = data;
    chat.addResponse(chat.chat);
  }
}

//Get This Event When Someone Clicks on a chat
void handleOnConnect(dynamic response) {
  print("response");
  print(response);
}

//Get This Event When Someone exits a chat
void handleOnDisconnect(dynamic response) {
  print("response");
  print(response);
}
