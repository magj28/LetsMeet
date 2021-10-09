import 'package:flutter/material.dart';
import 'package:meetapp/logic/model/screenArguments.dart';
import 'package:meetapp/logic/viewModel/searchViewModel.dart';
import 'package:meetapp/logic/viewModel/userViewModel.dart';
import 'package:meetapp/utils/color_utils.dart';
import 'package:meetapp/widgets/CommonAppBar.dart';
import 'package:meetapp/widgets/CommonDrawer.dart';
import 'package:meetapp/widgets/IconButtonWidget.dart';
import 'package:provider/provider.dart';
import '../widgets/UserListTile.dart';
import '../widgets/CircProgressIndicator.dart';

class Users extends StatefulWidget {
  const Users({Key? key}) : super(key: key);

  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserViewModel>(context, listen: false);
    final search = Provider.of<SearchViewModel>(context, listen: false);

    ScreenArguments screenArgs =
        ModalRoute.of(context)!.settings.arguments as ScreenArguments;
    return screenArgs != null
        ? Scaffold(
            appBar: CommonAppBar(
              title: screenArgs.keyword.toString(),
              action: [],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Provider.of<UserViewModel>(context).isFetchingData
                      ? CircProgressIndicator()
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              Provider.of<UserViewModel>(context).isFetchingData
                                  ? CircProgressIndicator()
                                  : SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        scrollDirection: Axis.vertical,
                                        itemCount: search.userList.length,
                                        itemBuilder: (context, index) {
                                          return new UserListTile(
                                              screenArgs.pageDirected ==
                                                      'conference call'
                                                  ? screenArgs
                                                      .token //if directed from video call, pass token of call
                                                  : null,
                                              screenArgs.pageDirected ==
                                                      'conference call'
                                                  ? screenArgs
                                                      .channel //if directed from video call, pass channel of call
                                                  : null,
                                              search.userList[index].userName,
                                              search.userList[index].firstName,
                                              search.userList[index].lastName,
                                              search.userList[index].userID);
                                        },
                                      )),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          )
        : Scaffold(
            appBar: CommonAppBar(
              title: "Contacts",
              action: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: IconButtonWidget(
                    icon: Icons.search,
                    color: ColorUtils.whiteColor,
                    onPressed: () async {
                      Navigator.pushNamed(context, '/searchPage');
                    },
                  ),
                ),
              ],
            ),
            drawer: CommonDrawer(),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Provider.of<UserViewModel>(context).isFetchingData
                      ? CircProgressIndicator()
                      : SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: user.userList.length,
                            itemBuilder: (context, index) {
                              return new UserListTile(
                                  null,
                                  null,
                                  user.userList[index].userName,
                                  user.userList[index].firstName,
                                  user.userList[index].lastName,
                                  user.userList[index].userID);
                            },
                          )),
                ],
              ),
            ),
          );
  }
}
