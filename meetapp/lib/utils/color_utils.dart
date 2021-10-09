import 'package:flutter/material.dart';
import 'package:meetapp/logic/model/Colors.dart';

//int index=1;
//ColorCustom? customColor;

class ColorUtils with ChangeNotifier{
  int? index;
  static const Color loginSignUp = Colors.blue;
  static const Color whiteColor = Colors.white;
  static const Color fillColor = Color(0x00FFFFFF);
  static const Color transparent = Colors.transparent;
  static const Color blackColor = Colors.black;
  static const Color greyColor = Colors.grey;
  static const Color acceptIcon = Colors.green;
  static const Color rejectIcon = Colors.redAccent;
  static const Color receiverChat = Color(0xffeeeeeee);
  static const Color listTileArrow = Color(0xffe0e0e0);
  static const Color bottomNavBarUnselected = Colors.black45;
  static const Color cancelLeaveDialogButtonColor = Color(0xffC5C5C5);

  static ColorCustom? color;

  getColorScheme(index){
    //teal
    if(index==0){
      Color primaryColor = Color(0xff005E7C);
      Color bottomNavBar = Color(0xff0094C6);
      Color circleAvatarColor = Color(0xff607D8B);
      Color senderChat = Color(0xff74b3ce);
      color= ColorCustom(primaryColor: primaryColor, circleAvatarColor: circleAvatarColor, bottomNavBar: bottomNavBar, senderChat: senderChat);
    }
    //violet
    else if(index==1){
      Color primaryColor = Color(0xff6247aa);
      Color bottomNavBar = Color(0xff815ac0);
      Color circleAvatarColor = Color(0xff9163cb);
      Color senderChat = Color(0xffb185db);
      color= ColorCustom(primaryColor: primaryColor, circleAvatarColor: circleAvatarColor, bottomNavBar: bottomNavBar, senderChat: senderChat);
    }
    //aqua
    else if(index==2){
      Color primaryColor = Color(0xff72efdd);
      Color bottomNavBar = Color(0xff56cfe1);
      Color circleAvatarColor = Color(0xff48bfe3);
      Color senderChat = Color(0xff64dfdf);
      color= ColorCustom(primaryColor: primaryColor, circleAvatarColor: circleAvatarColor, bottomNavBar: bottomNavBar, senderChat: senderChat);
    }
    //green
    else if(index==3){
      Color primaryColor = Color(0xff52b788);
      Color bottomNavBar = Color(0xff74c69d);
      Color circleAvatarColor = Color(0xff40916c);
      Color senderChat = Color(0xff95d5b2);
      color= ColorCustom(primaryColor: primaryColor, circleAvatarColor: circleAvatarColor, bottomNavBar: bottomNavBar, senderChat: senderChat);
    }
    //brown
    else if(index==4){
      Color primaryColor = Color(0xffb08968);
      Color bottomNavBar = Color(0xffddb892);
      Color circleAvatarColor = Color(0xff7f5539);
      Color senderChat = Color(0xffe6ccb2);
      color= ColorCustom(primaryColor: primaryColor, circleAvatarColor: circleAvatarColor, bottomNavBar: bottomNavBar, senderChat: senderChat);
    }
  }
}
