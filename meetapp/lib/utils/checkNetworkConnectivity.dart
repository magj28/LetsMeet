import 'dart:async';
import 'package:meetapp/utils/constants/app_constants.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meetapp/utils/constants/mainConstants.dart';
import 'dialog_utils.dart';

//Check Connectivity With Network
final Connectivity _connectivity = Connectivity();
String? _connectionStatus;

Future<bool> checkNetworkConnection(BuildContext context) async {
  String connectionStatus;

  try {
    connectionStatus = (await _connectivity.checkConnectivity()).toString();
  } on PlatformException catch (_) {
    connectionStatus = internetConnectionFailed;
  }

  _connectionStatus = connectionStatus;
  if (_connectionStatus == AppConstants.mobileConnectionStatus ||
      _connectionStatus == AppConstants.wifiConnectionStatus) {
    return true;
  } else {
    DialogUtils.showAlertDialog(context, internetNotConnected);
    return false;
  }
}
