import 'package:meetapp/logic/model/Chat.dart';
import 'package:meetapp/logic/model/res_call_request_model.dart';
import 'package:meetapp/logic/model/res_call_accept_model.dart';
import 'package:meetapp/screen/ConversationPage.dart';
import 'package:meetapp/screen/HomePage.dart';
import 'package:meetapp/screen/PickUpScreen.dart';
import 'package:meetapp/screen/VideoCallScreen.dart';
import 'package:meetapp/utils/constants/arg_constants.dart';
import 'package:flutter/material.dart';

import 'constants/route_constants.dart';

class NavigationUtils {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
    switch (settings.name) {
      case RouteConstants.routeCommon:
        return MaterialPageRoute(builder: (_) => HomePage());
      case RouteConstants.routePickUpScreen:
        ResCallRequestModel reqModel = args[ArgParams.resCallRequestModel];
        ResCallAcceptModel joinModel = args[ArgParams.resCallAcceptModel];
        bool isForOutGoing = args[ArgParams.isForOutGoing];
        String firstName = args[ArgParams.firstName];
        String lastName = args[ArgParams.lastName];
        return MaterialPageRoute(
            builder: (_) => PickUpScreen(
                  resCallRequestModel: reqModel,
                  resCallAcceptModel: joinModel,
                  isForOutGoing: isForOutGoing,
                  firstName: firstName,
                  lastName: lastName,
                ));
      case RouteConstants.routeVideoCall:
        String name = args[ArgParams.channelKey];
        String token = args[ArgParams.channelTokenKey];
        ResCallRequestModel reqModel = args[ArgParams.resCallRequestModel];
        ResCallAcceptModel joinModel = args[ArgParams.resCallAcceptModel];
        bool isForOutGoing = args[ArgParams.isForOutGoing];
        String userID = args["userID"];
        return MaterialPageRoute(
            builder: (_) => VideoCallingScreen(
                channelName: name,
                token: token,
                resCallRequestModel: reqModel,
                resCallAcceptModel: joinModel,
                isForOutGoing: isForOutGoing,
                userID: userID));
      case RouteConstants.routeMessage:
        AllChats allChats = args["allChats"];
        String origin = args["origin"];
        return MaterialPageRoute(
            builder: (_) =>
                new ConversationPage(allChats: allChats, origin: origin));
      default:
        return _errorRoute(" Coming soon...");
    }
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
          appBar: AppBar(title: Text('Error')),
          body: Center(child: Text(message)));
    });
  }

  static void pushReplacement(BuildContext context, String routeName,
      {Object? arguments}) {
    Navigator.of(context).pushReplacementNamed(routeName, arguments: arguments);
  }

  static Future<dynamic> push(BuildContext context, String routeName,
      {Object? arguments}) {
    return Navigator.of(context).pushNamed(routeName, arguments: arguments);
  }

  static void pop(BuildContext context, {dynamic args}) {
    Navigator.of(context).pop(args);
  }

  static Future<dynamic> pushAndRemoveUntil(
      BuildContext context, String routeName,
      {Object? arguments}) {
    return Navigator.of(context).pushNamedAndRemoveUntil(
        routeName, (route) => false,
        arguments: arguments);
  }

  static Future<dynamic> popAndPush(BuildContext context, String routeName,
      {Object? arguments}) {
    return Navigator.of(context)
        .popAndPushNamed(routeName, arguments: arguments);
  }
}
