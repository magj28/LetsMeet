import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:meetapp/logic/viewModel/userViewModel.dart';
import 'package:meetapp/utils/color_utils.dart';
import 'package:meetapp/widgets/CommonAppBar.dart';
import 'package:meetapp/widgets/CommonDrawer.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();

  final TextEditingController _firstNameController =
      new TextEditingController();
  final TextEditingController _lastNameController = new TextEditingController();
  final TextEditingController _userNameController = new TextEditingController();
  final TextEditingController _emailController = new TextEditingController();

  gettingInitValues() async {
    final user = Provider.of<UserViewModel>(context, listen: false);
    _firstNameController.text = user.user!.firstName;
    _lastNameController.text = user.user!.lastName;
    _userNameController.text = user.user!.userName;
    _emailController.text=user.user!.email;
  }

  @override
  void initState() {
    gettingInitValues();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserViewModel>(context, listen: false);
    _firstNameController.text = user.user!.firstName;
    _lastNameController.text = user.user!.lastName;
    _userNameController.text = user.user!.userName;
    _emailController.text=user.user!.email;

    return new Scaffold(
        appBar: CommonAppBar(title: "User Profile", action: []),
        drawer: CommonDrawer(),
        body: new Container(
          child: new ListView(
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          new Container(
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 25.0),
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 25.0, right: 25.0, top: 25.0),
                                      child: new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              new Text(
                                                'Personal Information',
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              _status
                                                  ? _getEditIcon()
                                                  : new Container(),
                                            ],
                                          )
                                        ],
                                      )),
                                  nameLabel('Username'),
                                  text('Username', "[a-zA-Z]",
                                      _userNameController, false),
                                  nameLabel('Email Id'),
                                  text('Email Id', "[a-zA-Z]",
                                      _emailController, false),
                                  nameLabel('First Name'),
                                  text('First Name', "[a-zA-Z]",
                                      _firstNameController, !_status),
                                  nameLabel('Last Name'),
                                  text('Last Name', "[a-zA-Z]",
                                      _lastNameController, !_status),
                                  !_status
                                      ? _getActionButtons()
                                      : new Container(),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Save"),
                textColor: ColorUtils.whiteColor,
                color: ColorUtils.acceptIcon,
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final user =
                        Provider.of<UserViewModel>(context, listen: false);
                    //if first name or last name is different from the one stored in db, edit details
                    if (user.user!.firstName != _firstNameController.text ||
                        user.user!.lastName != _lastNameController.text) {
                      await user.editDetails(user.user!.userID,
                          _firstNameController.text, _lastNameController.text);
                    }
                  }

                  setState(() {
                    _status = true;
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Cancel"),
                textColor: ColorUtils.whiteColor,
                color: ColorUtils.rejectIcon,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget nameLabel(name) {
    return Padding(
        padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 25.0),
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Text(
                  name,
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ));
  }

  Widget text(
      String name, regexp, TextEditingController controller, bool enabled) {
    return Padding(
        padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 2.0),
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            new Flexible(
              child: new TextFormField(
                inputFormatters: <TextInputFormatter>[
                  LengthLimitingTextInputFormatter(30),
                  new WhitelistingTextInputFormatter(RegExp(regexp))
                ],
                validator: (val) => val!.isEmpty ? "Enter " + name : null,
                controller: controller,
                enabled: enabled,
                autofocus: !_status,
              ),
            ),
          ],
        ));
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: ColorUtils.color!.bottomNavBar,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: ColorUtils.whiteColor,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}
