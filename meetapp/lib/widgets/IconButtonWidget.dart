import 'package:flutter/material.dart';

//custom icon button
class IconButtonWidget extends StatelessWidget {
  VoidCallback? onPressed;
  IconData? icon;
  Color? color;

  IconButtonWidget({this.onPressed, this.icon, this.color});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon!),
      color: color,
    );
  }
}
