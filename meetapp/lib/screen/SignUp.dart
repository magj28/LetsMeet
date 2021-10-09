import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meetapp/logic/viewModel/chatViewModel.dart';
import 'package:meetapp/logic/viewModel/userViewModel.dart';
import 'package:meetapp/utils/color_utils.dart';
import 'package:meetapp/widgets/TextField.dart';
import 'package:meetapp/widgets/ButtonForLogIn.dart';
import 'package:meetapp/widgets/ValidateError.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool usernameTaken = false;
  bool emptyFirstName = false;
  bool emptyLastName = false;
  bool emptyUserName = false;
  bool emptyPassword = false;

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments;
    String email = arg.toString();
    TextEditingController emailController = TextEditingController(text: email);
    final user = Provider.of<UserViewModel>(context, listen: false);
    final chat = Provider.of<ChatViewModel>(context, listen: false);
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
                    Container(
                      padding: EdgeInsets.all(10),
                      child: TextField(
                        controller: emailController,
                        enabled: false,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    TextFieldWidget('First Name', firstNameController, false),
                    ValidateErrorWidget(
                        emptyFirstName, "First Name cannot be empty"),
                    TextFieldWidget('Last Name', lastNameController, false),
                    ValidateErrorWidget(
                        emptyLastName, "Last Name cannot be empty"),
                    TextFieldWidget('User Name', userNameController, false),
                    ValidateErrorWidget(
                        emptyUserName, "Username cannot be empty"),
                    TextFieldWidget("Password", passwordController, true),
                    ValidateErrorWidget(
                        emptyPassword, "Password cannot be empty"),
                    buttonForLogIn('Sign Up', () async {
                      await user.checkUserNameUnique(userNameController.text);

                      if (firstNameController.text.length == 0)
                        emptyFirstName = true;
                      if (lastNameController.text.length == 0)
                        emptyLastName = true;
                      if (userNameController.text.length == 0)
                        emptyUserName = true;
                      if (passwordController.text.length == 0)
                        emptyPassword = true;
                      if (emptyFirstName == true ||
                          emptyLastName == true ||
                          emptyUserName == true ||
                          emptyPassword == true) {
                        setState(() {});
                      }

                      if (userNameController.text.length > 0) {
                        //if username is available
                        if (user.message == 'Username available') {
                          await user.signUp(
                              firstNameController.text,
                              lastNameController.text,
                              userNameController.text,
                              passwordController.text,
                              emailController.text);
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
                          prefs.setInt(
                              'index', 0); //store index of theme by default:0
                          Provider.of<ColorUtils>(context, listen: false)
                              .getColorScheme(0);
                          Navigator.popAndPushNamed(context, '/homePage');
                        }
                        //if username is taken
                        if (user.message == 'Username not available') {
                          setState(() {
                            usernameTaken = true;
                          });
                        }
                      }
                    }),
                    ValidateErrorWidget(usernameTaken, "Username already exists"),
                    Container(
                        child: Row(
                      children: <Widget>[
                        Text("Already have an account?"),
                        TextButton(
                          child: Text(
                            'Log in',
                            style: TextStyle(
                                fontSize: 20, color: ColorUtils.loginSignUp),
                          ),
                          onPressed: () {
                            Navigator.popAndPushNamed(context, '/login');
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
