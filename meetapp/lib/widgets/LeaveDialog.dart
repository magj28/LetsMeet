import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:meetapp/utils/color_utils.dart';
import 'package:meetapp/utils/dimensions.dart';
import 'package:meetapp/utils/navigation_utils.dart';

//dialog displayed at the end of video call
class LeaveDialog extends StatefulWidget {
  final String title;
  final String yesText;
  final String noText;
  final Function onYesAction;

  LeaveDialog(
      {required this.title,
      required this.yesText,
      required this.noText,
      required this.onYesAction});

  @override
  _LeaveDialogState createState() => _LeaveDialogState();
}

class _LeaveDialogState extends State<LeaveDialog> {
  @override
  Widget build(BuildContext context) => Material(
        type: MaterialType.transparency,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Center(
            child: _getDialogLayout(context),
          ),
        ),
      );

  _getDialogLayout(BuildContext context) => SingleChildScrollView(
        child: Wrap(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: ColorUtils.whiteColor,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  width: MediaQuery.of(context).size.width * 0.85,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(
                      horizontal: spacingLarge, vertical: spacingXXXLarge),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          widget.title,
                          style: TextStyle(
                              color: ColorUtils.color!.primaryColor,
                              fontSize: buttonLabelFontSize),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: spacingXXLarge,
                        ),
                        RaisedButton(
                            color: ColorUtils.color!.primaryColor,
                            onPressed: () {
                              dismissAlertDialog(context);

                              if (widget.onYesAction != null) {
                                widget.onYesAction();
                              }
                            },
                            child: Text(
                              widget.yesText,
                              style: TextStyle(color: ColorUtils.whiteColor),
                            )),
                        SizedBox(
                          height: spacingLarge,
                        ),
                        RaisedButton(
                          color: ColorUtils.cancelLeaveDialogButtonColor,
                          onPressed: () {
                            dismissAlertDialog(context);
                          },
                          child: Text(widget.noText),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}

void dismissAlertDialog(BuildContext context) {
  NavigationUtils.pop(context);
}

Future<dynamic> showCallLeaveDialog(BuildContext context, String title,
    String yesText, String noText, Function onYesAction) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) {
      return LeaveDialog(
        title: title,
        yesText: yesText,
        noText: noText,
        onYesAction: onYesAction,
      );
    },
  );
}
