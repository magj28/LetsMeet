import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:meetapp/utils/constants/mainConstants.dart';
import 'dialog_utils.dart';

class PermissionUtils {
  static void requestPermission(
    List<PermissionGroup> permission,
    BuildContext context, {
    Function? permissionGrant,
    Function? permissionDenied,
    Function? permissionNotAskAgain,
    bool isOpenSettings = false,
    bool isShowMessage = false,
  }) {
    PermissionHandler().requestPermissions(permission).then((statuses) {
      var allPermissionGranted = true;

      statuses.forEach((key, value) {
        allPermissionGranted =
            allPermissionGranted && (value == PermissionStatus.granted);
      });

      if (allPermissionGranted) {
        if (permissionGrant != null) {
          permissionGrant();
        }
      } else {
        if (permissionDenied != null) {
          permissionDenied();
        }
        if (isOpenSettings) {
          DialogUtils.showOkCancelAlertDialog(
            context: context,
            message: alertPermissionNotRestricted,
            cancelButtonTitle: Platform.isAndroid ? no : cancel,
            okButtonTitle: Platform.isAndroid ? yes : ok,
            cancelButtonAction: () {},
            okButtonAction: () {
              PermissionHandler().openAppSettings();
            },
          );
        } else if (isShowMessage) {
          DialogUtils.showAlertDialog(context, alertPermissionNotRestricted);
        }
      }
    });
  }
}
