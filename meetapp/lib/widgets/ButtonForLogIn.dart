import 'package:flutter/material.dart';
import 'package:meetapp/utils/color_utils.dart';

//login/Sign up button
class buttonForLogIn extends StatelessWidget {
  String buttonDisplayText;
  VoidCallback onPressed;

  buttonForLogIn(this.buttonDisplayText, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(primary: ColorUtils.loginSignUp),
            child: Text(
              buttonDisplayText,
              style: TextStyle(color: ColorUtils.whiteColor),
            ),
            onPressed: onPressed,
          )),
    );
  }
}
