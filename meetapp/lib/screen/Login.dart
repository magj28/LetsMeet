import 'package:flutter/material.dart';
import 'package:meetapp/logic/viewModel/callRecordViewModel.dart';
import 'package:meetapp/logic/viewModel/chatViewModel.dart';
import 'package:meetapp/logic/viewModel/userViewModel.dart';
import 'package:meetapp/utils/color_utils.dart';
import 'package:meetapp/widgets/TextField.dart';
import 'package:meetapp/widgets/ButtonForLogIn.dart';
import 'package:meetapp/widgets/ValidateError.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _State();
}

class _State extends State<Login> {
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool wrongCredentials = false;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserViewModel>(context, listen: false);
    final chat = Provider.of<ChatViewModel>(context, listen: false);
    final callRecord = Provider.of<CallRecordViewModel>(context, listen: false);
    return Scaffold(
        body: Center(
      child: Container(
        child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Let's Meet!",
                      style: TextStyle(
                          color: ColorUtils.loginSignUp,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                TextFieldWidget('User Name', nameController, false),
                TextFieldWidget("Password", passwordController, true),
                buttonForLogIn(
                  'Login',
                  () async {
                    await user.login(
                        nameController.text, passwordController.text);
                    if (user.message == 'User login') {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString(
                          'userID',
                          user.user!
                              .userID); //store userID in shared Preference
                      prefs.setBool("isLoggedIn",
                          true); //store isLogged in bool value in shared Preference
                      await user.allUsers(user.user!.userID);
                      await chat.getAllChat(user.user!.userID);
                      await callRecord.getCallRecords(user.user!.userID);
                      prefs.setInt('index',
                          0); //store index of theme by default:0
                      Provider.of<ColorUtils>(context, listen: false)
                          .getColorScheme(0);
                      Navigator.popAndPushNamed(context, '/homePage');
                    } else {
                      setState(() {
                        wrongCredentials = true;
                      });
                    }
                  },
                ),
                ValidateErrorWidget(
                    wrongCredentials, "Incorrect username or password"),
                Container(
                    child: Row(
                  children: <Widget>[
                    Text("Don't have an account?"),
                    TextButton(
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                            fontSize: 20, color: ColorUtils.loginSignUp),
                      ),
                      // onPressed: () {
                      //   Navigator.popAndPushNamed(context, '/signUp');
                      // },
                      onPressed: () {
                        Navigator.popAndPushNamed(context, '/emailVerify');
                      },
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ))
              ],
            )),
      ),
    ));
  }
}
