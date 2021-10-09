import 'package:flutter/material.dart';

//custom text field
class TextFieldWidget extends StatelessWidget {
  String labelText;
  TextEditingController controller;
  bool obscureText;

  TextFieldWidget(this.labelText, this.controller, this.obscureText);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        obscureText: obscureText,
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: labelText,
        ),
      ),
    );
  }
}
