import 'package:flutter/material.dart';
import 'package:meetapp/utils/color_utils.dart';

//custom validatorfor textfield widget
class ValidateErrorWidget extends StatelessWidget {
  String errorText;
  bool validateText;

  ValidateErrorWidget(this.validateText, this.errorText);

  @override
  Widget build(BuildContext context) {
    return validateText == true
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Container(
              child: Text(
                errorText,
                style: TextStyle(color: ColorUtils.rejectIcon),
              ),
            ),
          )
        : Container();
  }
}
