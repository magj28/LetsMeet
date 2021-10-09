import 'dart:async';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:meetapp/logic/model/res_call_accept_model.dart';
import 'package:meetapp/logic/model/res_call_request_model.dart';
import 'package:meetapp/logic/model/screenArguments.dart';
import 'package:meetapp/logic/viewModel/callRecordViewModel.dart';
import 'package:meetapp/logic/viewModel/chatViewModel.dart';
import 'package:meetapp/logic/viewModel/userViewModel.dart';
import 'package:meetapp/utils/color_utils.dart';
import 'package:meetapp/utils/constants/app_constants.dart';
import 'package:meetapp/utils/constants/arg_constants.dart';
import 'package:meetapp/utils/constants/file_constants.dart';
import 'package:meetapp/utils/constants/mainConstants.dart';
import 'package:meetapp/utils/constants/route_constants.dart';
import 'package:meetapp/utils/constants/socketConstants.dart';
import 'package:meetapp/utils/dimensions.dart';
import 'package:meetapp/utils/navigation_utils.dart';
import 'package:meetapp/utils/socketManager.dart';
import 'package:meetapp/widgets/LeaveDialog.dart';
import 'package:meetapp/widgets/Timer.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

class VideoCallingScreen extends StatefulWidget {
  final String channelName;
  final String? token;
  final ResCallRequestModel? resCallRequestModel;
  final ResCallAcceptModel? resCallAcceptModel;
  final bool? isForOutGoing;
  final String userID;

  VideoCallingScreen(
      {required this.channelName,
      this.token,
      this.resCallRequestModel,
      this.resCallAcceptModel,
      this.isForOutGoing,
      required this.userID});

  @override
  _VideoCallingScreenState createState() => _VideoCallingScreenState();
}

class _VideoCallingScreenState extends State<VideoCallingScreen> {
  bool _joined = false;
  int? _remoteUid;
  bool _switch = false;
  List<String> _infoStrings = <String>[];
  static List<int> _users = <int>[];
  RtcEngine? _engine;
  bool _isFront = false;
  bool _reConnectingRemoteView = false;
  final GlobalKey<TimerViewState> _timerKey = GlobalKey();
  bool _mutedAudio = false;
  bool _mutedVideo = false;
  List<String>? usersID = <String>[];

  @override
  void initState() {
    super.initState();
    Wakelock.enable(); // Turn on wakelock feature till call is running
    initializeCalling();
  }

  @override
  void dispose() {
    _users.clear();
    _engine!.leaveChannel();
    _engine!.destroy();
    Wakelock.disable(); // Turn off wakelock feature after call end
    super.dispose();
  }

  //Initialize All The Setup For Agora Video Call
  Future<void> initializeCalling() async {
    if (AppConstants.agoraAppId.isEmpty) {
      setState(() {
        _infoStrings.add(
          'APP_ID missing, please provide your APP_ID in settings.dart',
        );
        _infoStrings.add('Agora Engine is not starting');
      });
      return;
    }
    Future.delayed(Duration.zero, () async {
      await _initAgoraRtcEngine();
      _addAgoraEventHandlers();
      await _engine!.joinChannel(widget.token, widget.channelName, null, 0);
    });
  }

  //Initialize Agora RTC Engine
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(AppConstants.agoraAppId);
    await _engine!.enableVideo();
  }

  //Switch Camera
  _onAddingUser() {
    initSocketManager(context);
    Navigator.pushNamed(context, '/searchPage',
        arguments: ScreenArguments(
            'conference call', null, widget.token, widget.channelName));
  }

  //Switch Camera
  _onToggleCamera() {
    _engine?.switchCamera()?.then((value) {
      setState(() {
        _isFront = !_isFront;
      });
    }).catchError((err) {});
  }

  //Audio On / Off
  void _onToggleMuteAudio() {
    setState(() {
      _mutedAudio = !_mutedAudio;
    });
    _engine!.muteLocalAudioStream(_mutedAudio);
  }

  //Video On / Off
  void _onToggleMuteVideo() {
    setState(() {
      _mutedVideo = !_mutedVideo;
    });
    _engine!.muteLocalVideoStream(_mutedVideo);
    _engine!.enableLocalVideo(!_mutedVideo);
  }

  //Agora Events Handler To Implement Ui/UX Based On Your Requirements
  void _addAgoraEventHandlers() async {
    _engine!.setEventHandler(RtcEngineEventHandler(
      error: (code) {
        setState(() {
          final info = 'onError:$code ${code.index}';
          _infoStrings.add(info);
        });
      },
      joinChannelSuccess: (channel, uid, elapsed) {
        setState(() {
          _joined = true;
          final info = 'onJoinChannel: $channel, uid: $uid';
          _infoStrings.add(info);
        });
      },
      leaveChannel: (stats) {
        setState(() {
          _infoStrings.add('onLeaveChannel');
          _users.clear();
          usersID!.clear();
        });
      },
      userJoined: (uid, elapsed) {
        setState(() {
          final info = 'userJoined: $uid';
          _infoStrings.add(info);
          _remoteUid = uid;
          _users.add(uid);
          usersID!.add(widget.userID);
        });
      },
      userOffline: (uid, elapsed) {
        if (elapsed == UserOfflineReason.Dropped) {
          Wakelock.disable();
        } else {
          setState(() {
            final info = 'userOffline: $uid';
            _infoStrings.add(info);
            //_remoteUid = null;
            _timerKey.currentState?.cancelTimer();
            _users.remove(uid);
            usersID!.remove(widget.userID);
          });
        }
      },
      firstRemoteVideoFrame: (uid, width, height, elapsed) {
        setState(() {
          final info = 'firstRemoteVideo: $uid ${width}x $height';
          _infoStrings.add(info);
        });
      },
    ));
  }

  // Create UI with local view and remote view
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await _onBackPressed(context),
      child: Scaffold(
        backgroundColor: ColorUtils.blackColor,
        body: Stack(
          children: [
            _viewRows(),
            _bottomPortionWidget(context),
            //to mute mic, switch off camera, turn around camera, end call
            _timerView(),
            //shows duration of call
            _newUser(context),
            //to add new User to meeting max. 4 participants
          ],
        ),
      ),
    );
  }

  //Get This Alert Dialog When User Press On Back Button
  _onBackPressed(BuildContext context) {
    showCallLeaveDialog(
        context, labelEndCall, labelEndCallNow, labelEndCallCancel, () {
      _onCallEnd(context);
    });
  }

  // Helper function to get list of native views
  List<Widget> _getRenderViews() {
    final List<StatefulWidget> list = [];
    list.add(rtc_local_view.SurfaceView());
    _users
        .forEach((int uid) => list.add(rtc_remote_view.SurfaceView(uid: uid)));
    return list;
  }

  // Video view wrapper
  Widget _videoView(view) {
    return Expanded(child: Container(child: view));
  }

  // Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Expanded(
      child: Row(
        children: wrappedViews,
      ),
    );
  }

  //Timer Ui
  Widget _timerView() => Positioned(
        top: 45,
        left: spacingXXXSLarge,
        child: Opacity(
          opacity: 1,
          child: Row(
            children: [
              SvgPicture.asset(FileConstants.icTimer, width: 12, height: 12),
              SizedBox(width: spacingMedium),
              TimerView(
                key: _timerKey,
              )
            ],
          ),
        ),
      );

  // Ui & UX For Adding Person to Call
  Widget _newUser(BuildContext context) => Positioned(
        top: spacingXXMLarge,
        right: spacingMedium,
        child: Row(
          children: [
            RawMaterialButton(
              onPressed: _onToggleCamera,
              child: Icon(
                Icons.switch_camera,
                color: ColorUtils.whiteColor,
                size: smallIconSize,
              ),
              shape: CircleBorder(),
              elevation: 2.0,
              fillColor: ColorUtils.fillColor,
            ),
            _getRenderViews().length == 4
                ? Container()
                : RawMaterialButton(
                    onPressed: _onAddingUser,
                    child: Icon(
                      Icons.person_add,
                      color: ColorUtils.whiteColor,
                      size: smallIconSize,
                    ),
                    shape: CircleBorder(),
                    elevation: 2.0,
                    fillColor: ColorUtils.fillColor,
                  ),
          ],
        ),
      );

  Widget _viewRows() {
    final views = _getRenderViews();
    switch (views.length) {
      case 1:
        return Column(
          children: <Widget>[_videoView(views[0])],
        );
      case 2:
        return Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
            _expandedVideoRow([views[1]])
          ],
        );
      case 3:
        return Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        );
      case 4:
        return Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        );
      default:
    }
    return Container();
  }

  // Ui & UX For Bottom Portion (Switch Camera,Video On/Off,Mic On/Off, Call End)
  Widget _bottomPortionWidget(BuildContext context) => Container(
        margin: EdgeInsets.only(
            bottom: spacingLarge, left: spacingXXMLarge, right: spacingXLarge),
        alignment: Alignment.bottomCenter,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: spacingMedium),
                child: RawMaterialButton(
                  onPressed: () {
                    showCallLeaveDialog(context, labelEndCall, labelEndCallNow,
                        labelEndCallCancel, () {
                      _onCallEnd(context);
                    });
                  },
                  child: Icon(
                    Icons.call_end,
                    color: ColorUtils.whiteColor,
                    size: imageMTiny,
                  ),
                  shape: CircleBorder(),
                  elevation: 2.0,
                  fillColor: ColorUtils.rejectIcon,
                  padding: const EdgeInsets.all(spacingMedium),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _getRenderViews().length > 2
                      ? Container()
                      : RawMaterialButton(
                          onPressed: () async {
                            final chat = Provider.of<ChatViewModel>(context,
                                listen: false);
                            final user = Provider.of<UserViewModel>(context,
                                listen: false);
                            final otherUserID = widget.isForOutGoing == true
                                ? widget.resCallAcceptModel!.otherUserId
                                : usersID![0];
                            await chat.getChat(otherUserID, user.user!.userID);
                            await user.findName(otherUserID);
                            initSocketManager(context);
                            emit(SocketConstants.connectMessage,
                                ({"otherUserId": otherUserID}));
                            NavigationUtils.push(
                                context, RouteConstants.routeMessage,
                                arguments: {
                                  "allChats": chat.chat,
                                  "origin": "vc"
                                });
                          },
                          child: Icon(
                            Icons.chat,
                            color: ColorUtils.whiteColor,
                            size: smallIconSize,
                          ),
                          shape: CircleBorder(),
                          elevation: 2.0,
                          fillColor: ColorUtils.transparent,
                          padding: const EdgeInsets.all(spacingMedium),
                        ),
                  RawMaterialButton(
                    onPressed: _onToggleMuteVideo,
                    child: Icon(
                      _mutedVideo ? Icons.videocam_off : Icons.videocam,
                      color: ColorUtils.whiteColor,
                      size: smallIconSize,
                    ),
                    shape: CircleBorder(),
                    elevation: 2.0,
                    fillColor: _mutedVideo
                        ? ColorUtils.fillColor
                        : ColorUtils.transparent,
                    padding: const EdgeInsets.all(spacingMedium),
                  ),
                  RawMaterialButton(
                    onPressed: _onToggleMuteAudio,
                    child: Icon(
                      _mutedAudio ? Icons.mic_off : Icons.mic,
                      color: ColorUtils.whiteColor,
                      size: smallIconSize,
                    ),
                    shape: CircleBorder(),
                    elevation: 2.0,
                    fillColor: _mutedAudio
                        ? ColorUtils.fillColor
                        : ColorUtils.transparent,
                    padding: const EdgeInsets.all(spacingMedium),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  //Use This Method To End Call
  void _onCallEnd(BuildContext context) async {
    Wakelock.disable(); // Turn off wakelock feature after call end

    final callRecord = Provider.of<CallRecordViewModel>(context, listen: false);
    if (usersID!.length > 0 || usersID == null) {
      if (callRecord.callRecord == null) {
        await callRecord.fetchCallRecord(
            widget.resCallAcceptModel!.otherUserId, usersID![0]);
      }
    }
    if (callRecord.callRecord != null)
      await callRecord.callRecordEnding(
          callRecord.callRecord!.id, callRecord.callRecord!.date);

    //Emit Reject Call Event Into Socket
    if (usersID!.length == 1)
      emit(
          SocketConstants.rejectCall,
          ({
            ArgParams.connectId: widget.isForOutGoing == true
                ? widget.resCallAcceptModel!.otherUserId
                : widget.resCallRequestModel!.id,
          }));

    NavigationUtils.pushAndRemoveUntil(
      context,
      RouteConstants.routeCommon,
    );
  }
}
