import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meetapp/logic/model/screenArguments.dart';
import 'package:meetapp/logic/viewModel/searchViewModel.dart';
import 'package:meetapp/logic/viewModel/userViewModel.dart';
import 'package:meetapp/utils/color_utils.dart';
import 'package:meetapp/widgets/CommonAppBar.dart';
import 'package:meetapp/widgets/UserListTile.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String userID = '';

  void gettingInitValues() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    userID = sharedPreferences.getString('userID')!;
  }

  @override
  void initState() {
    gettingInitValues();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final search = Provider.of<SearchViewModel>(context, listen: false);
    final user = Provider.of<UserViewModel>(context, listen: false);

    ScreenArguments screenArgs =
        ModalRoute.of(context)!.settings.arguments as ScreenArguments;

    return Scaffold(
      appBar: CommonAppBar(
        title: "Search",
        action: [],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: ColorUtils.color!.primaryColor,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: TextField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      filled: true,
                      fillColor: ColorUtils.whiteColor),
                  inputFormatters: [LengthLimitingTextInputFormatter(10)],
                  style: TextStyle(color: ColorUtils.blackColor, fontSize: 18),
                  onSubmitted: (String val) async {
                    await search.getSearchItems(val.trim(), userID);
                    screenArgs == null
                        ? Navigator.popAndPushNamed(context, '/users',
                            arguments: ScreenArguments(
                                'search', val.trim(), null, null))
                        : //directed from video call to add user to conference call
                        Navigator.popAndPushNamed(context, '/users',
                            arguments: ScreenArguments(
                                screenArgs.pageDirected,
                                val.trim(),
                                screenArgs.token,
                                screenArgs.channel));
                  },
                ),
              ),
            ),
            SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: user.userList.length,
                  itemBuilder: (context, index) {
                    return new UserListTile(
                        screenArgs.token,
                        screenArgs.channel,
                        user.userList[index].userName,
                        user.userList[index].firstName,
                        user.userList[index].lastName,
                        user.userList[index].userID);
                  },
                ))
          ],
        ),
      ),
    );
  }
}
