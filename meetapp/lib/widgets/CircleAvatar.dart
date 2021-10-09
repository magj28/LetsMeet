import 'dart:math';
import 'package:flutter/material.dart';
import 'package:meetapp/utils/color_utils.dart';

//custom circle avatar implying profile icon
class circleAvatar extends StatefulWidget {
  String? firstName;
  String? lastName;
  bool padding;
  double fontsize;

  circleAvatar(this.firstName, this.lastName, this.padding, this.fontsize);

  @override
  _circleAvatarState createState() => _circleAvatarState();
}

class _circleAvatarState extends State<circleAvatar> {
  @override
  Widget build(BuildContext context) {
    Random random = new Random();

    return CircleAvatar(
      maxRadius: widget.padding ? MediaQuery.of(context).size.width / 12 : 0.0,
      backgroundColor: ColorUtils.color!.circleAvatarColor.withOpacity(0.8),
      child: Text(
        widget.firstName!.substring(0, 1) +
            " " +
            widget.lastName!.substring(0, 1),
        style: TextStyle(
            color: ColorUtils.blackColor.withOpacity(0.8),
            fontSize: widget.fontsize,
            fontWeight: FontWeight.w400),
      ),
    );
  }
}
