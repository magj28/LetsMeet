import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:meetapp/logic/model/res_call_accept_model.dart';
import 'package:meetapp/logic/model/res_call_request_model.dart';
import 'package:meetapp/logic/viewModel/callRecordViewModel.dart';
import 'package:meetapp/logic/viewModel/userViewModel.dart';
import 'package:meetapp/utils/checkNetworkConnectivity.dart';
import 'package:meetapp/utils/color_utils.dart';
import 'package:meetapp/utils/constants/arg_constants.dart';
import 'package:meetapp/utils/constants/mainConstants.dart';
import 'package:meetapp/utils/constants/route_constants.dart';
import 'package:meetapp/utils/constants/socketConstants.dart';
import 'package:meetapp/utils/dimensions.dart';
import 'package:meetapp/utils/navigation_utils.dart';
import 'package:meetapp/utils/permission_utils.dart';
import 'package:meetapp/utils/socketManager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

class PickUpScreen extends StatefulWidget {
  final ResCallRequestModel? resCallRequestModel;
  final ResCallAcceptModel? resCallAcceptModel;
  final bool isForOutGoing;
  String? firstName;
  String? lastName;

  PickUpScreen(
      {this.resCallRequestModel,
      this.resCallAcceptModel,
      this.isForOutGoing = false,
      this.firstName,
      this.lastName});

  @override
  _PickUpScreenState createState() => _PickUpScreenState();
}

class _PickUpScreenState extends State<PickUpScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    Wakelock.enable(); // Turn on wakelock feature till call is running
    //To Play Ringtone
    if (widget.isForOutGoing == false)
      FlutterRingtonePlayer.play(
          android: AndroidSounds.ringtone,
          ios: IosSounds.electronic,
          looping: true,
          volume: 0.5,
          asAlarm: false);
    _timer = Timer(const Duration(milliseconds: 60 * 1000), _endCall);
  }

  @override
  void dispose() {
    //To Stop Ringtone
    FlutterRingtonePlayer.stop();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getScreenSize(context);
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 0.4, 0.8],
            colors: [
              ColorUtils.color!.circleAvatarColor,
              ColorUtils.color!.primaryColor,
              ColorUtils.blackColor
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              widget.isForOutGoing ? outGoingCallTitle : pickUpCallTitle,
              style: TextStyle(
                  color: ColorUtils.whiteColor,
                  fontSize: headerTitleSize,
                  fontWeight: fontWeightRegular),
            ),
            SizedBox(height: spacingXXXSLarge),
            _getImageUrlWidget(),
            SizedBox(height: spacingLarge),
            Text(widget.firstName! + " " + widget.lastName!,
                style: TextStyle(
                    color: ColorUtils.whiteColor,
                    fontSize: headerTitleSize,
                    fontWeight: fontWeightRegular)),
            SizedBox(height: spacingXXXSLarge),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _callingButtonWidget(context, false),
                !widget.isForOutGoing
                    ? _callingButtonWidget(context, true)
                    : SizedBox(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //To Display Profile Image Of User
  _getImageUrlWidget() => ClipOval(
      child: CircleAvatar(
          backgroundColor: ColorUtils.whiteColor,
          radius: screenSize!.width * 0.2,
          child: Text(
            widget.firstName!.substring(0, 1) +
                " " +
                widget.lastName!.substring(0, 1),
            style: TextStyle(fontSize: spacingXXXLarge), // Any ImageUrl
          )));

  //Reusable Accept & Reject Call Ui/Ux
  _callingButtonWidget(BuildContext context, bool isCall) => RawMaterialButton(
      onPressed: () {
        if (isCall) {
          _timer?.cancel();
          pickUpCallPressed(context);
        } else {
          _endCall();
        }
      },
      child: Icon(isCall ? Icons.call : Icons.call_end,
          color: ColorUtils.whiteColor, size: imageMTiny),
      shape: CircleBorder(),
      elevation: 2.0,
      fillColor: isCall ? ColorUtils.acceptIcon : ColorUtils.rejectIcon,
      padding: const EdgeInsets.all(spacingMedium));

  //Call This Method When User Pressed On Accept Call Button
  void pickUpCallPressed(BuildContext context) {
    PermissionUtils.requestPermission(
        [PermissionGroup.camera, PermissionGroup.microphone], context,
        isOpenSettings: true, permissionGrant: () async {
      FlutterRingtonePlayer.stop();
      if (await checkNetworkConnection(context)) {
        //Emit Accept Call Event Into Socket
        emit(
            SocketConstants.acceptCall,
            ({
              ArgParams.connectId: widget.resCallRequestModel!.id,
              ArgParams.channelKey: widget.resCallRequestModel!.channel,
              ArgParams.channelTokenKey: widget.resCallRequestModel!.token,
            }));

        //post into database beginning of call
        final callRecord =
            Provider.of<CallRecordViewModel>(context, listen: false);
        final user = Provider.of<UserViewModel>(context, listen: false);
        await callRecord.callRecordBeginning(
            user.user!.userID,
            widget.resCallRequestModel!.id,
            "Accepted",
            widget.resCallRequestModel!.channel,
            widget.resCallRequestModel!.token);

        NavigationUtils.pushAndRemoveUntil(
            context, RouteConstants.routeVideoCall,
            arguments: {
              ArgParams.channelKey: widget.resCallRequestModel!.channel,
              ArgParams.channelTokenKey: widget.resCallRequestModel!.token,
              ArgParams.resCallRequestModel: widget.resCallRequestModel,
              ArgParams.resCallAcceptModel: ResCallAcceptModel(),
              ArgParams.isForOutGoing: widget.isForOutGoing,
              "userID": widget.resCallRequestModel!.id
            });
      }
    });
  }

  //Call This Method When User Pressed On Reject Call Button
  _endCall() async {
    Wakelock.disable(); // Turn off wakelock feature after call end
    FlutterRingtonePlayer.stop(); // To Stop Ringtone
    //Emit Reject Call Event Into Socket
    emit(
        SocketConstants.rejectCall,
        ({
          ArgParams.connectId: widget.isForOutGoing
              ? widget.resCallAcceptModel!.otherUserId
              : widget.resCallRequestModel!.id,
        }));

    final callRecord = Provider.of<CallRecordViewModel>(context, listen: false);
    final user = Provider.of<UserViewModel>(context, listen: false);
    await callRecord.callRecordBeginning(
        user.user!.userID,
        widget.resCallRequestModel!.id,
        "Rejected",
        widget.resCallRequestModel!.channel,
        widget.resCallRequestModel!.token);

    NavigationUtils.pop(context);
  }
}
