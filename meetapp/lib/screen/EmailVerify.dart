import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';
import 'package:meetapp/logic/viewModel/userViewModel.dart';
import 'package:meetapp/utils/color_utils.dart';
import 'package:meetapp/widgets/ButtonForLogIn.dart';
import 'package:meetapp/widgets/TextField.dart';
import 'package:meetapp/widgets/ValidateError.dart';
import 'package:provider/provider.dart';

class EmailVerify extends StatefulWidget {
  @override
  _EmailVerifyState createState() => _EmailVerifyState();
}

class _EmailVerifyState extends State<EmailVerify> {
  //the boolean to handle the dynamic operations
  bool submitValid = false;

  //testediting controllers to get the value from text fields
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _otpcontroller = TextEditingController();

  bool emailExists = false;
  bool invalidEmail = false;
  bool verifyOTP = false;
  bool OTPwrong = false;

  @override
  void initState() {
    super.initState();
  }

  //a void function to verify if the Data provided is true
  void verify() {
    verifyOTP = EmailAuth.validate(
        receiverMail: _emailcontroller.value.text,
        userOTP: _otpcontroller.value.text);
    if (verifyOTP) {
      Navigator.popAndPushNamed(context, '/signUp',
          arguments: _emailcontroller.value.text);
    } else {
      setState(() {
        OTPwrong = true;
      });
    }
    print(EmailAuth.validate(
        receiverMail: _emailcontroller.value.text,
        userOTP: _otpcontroller.value.text));
  }

  //a void funtion to send the OTP to the user
  void sendOtp() async {
    final user = Provider.of<UserViewModel>(context, listen: false);
    await user.checkEmailUnique(_emailcontroller.value.text);
    String p =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = new RegExp(p);
    bool emailValid = regExp.hasMatch(_emailcontroller.value.text);
    if (emailValid) {
      if (user.message == 'Email available') {
        EmailAuth.sessionName = "Let's Meet!";
        bool result =
            await EmailAuth.sendOtp(receiverMail: _emailcontroller.value.text);
        if (result) {
          setState(() {
            submitValid = true;
            emailExists = false;
            invalidEmail = false;
          });
        }
      }
      if (user.message == 'Email not available') {
        setState(() {
          emailExists = true;
          invalidEmail = false;
        });
      }
    } else {
      setState(() {
        invalidEmail = true;
        emailExists = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              TextFieldWidget('Enter Email Id', _emailcontroller, false),
              buttonForLogIn('Send OTP', sendOtp),
              emailExists
                  ? ValidateErrorWidget(emailExists, 'Email already exists')
                  : Container(),
              invalidEmail
                  ? ValidateErrorWidget(invalidEmail, 'Email is Invalid.')
                  : Container(),
              //A dynamically rendering text field
              (submitValid)
                  ? TextFieldWidget('Enter OTP', _otpcontroller, false)
                  : Container(height: 1),
              (submitValid)
                  ? buttonForLogIn('Verify OTP', verify)
                  : SizedBox(height: 1),
              OTPwrong
                  ? ValidateErrorWidget(OTPwrong, 'Wrong OTP')
                  : Container(),

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
          ),
        )),
      );
  }
}
