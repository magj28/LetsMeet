import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meetapp/logic/viewModel/callRecordViewModel.dart';
import 'package:meetapp/logic/viewModel/chatViewModel.dart';
import 'package:meetapp/logic/viewModel/searchViewModel.dart';
import 'package:meetapp/logic/viewModel/userViewModel.dart';
import 'package:meetapp/screen/Themes.dart';
import 'package:meetapp/screen/ConversationPage.dart';
import 'package:meetapp/screen/ConversationPageList.dart';
import 'package:meetapp/screen/HomePage.dart';
import 'package:meetapp/screen/Login.dart';
import 'package:meetapp/screen/SearchPage.dart';
import 'package:meetapp/screen/SignUp.dart';
import 'package:meetapp/screen/SplashScreen.dart';
import 'package:meetapp/screen/UserProfile.dart';
import 'package:meetapp/screen/EmailVerify.dart';
import 'package:meetapp/utils/color_utils.dart';
import 'package:meetapp/utils/navigation_utils.dart';
import 'package:meetapp/screen/Users.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider.value(value: UserViewModel()),
    ChangeNotifierProvider.value(value: SearchViewModel()),
    ChangeNotifierProvider.value(value: CallRecordViewModel()),
    ChangeNotifierProvider.value(value: ChatViewModel()),
    ChangeNotifierProvider.value(value: ColorUtils())
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Let's Meet!",
      home: SplashScreen(),
      onGenerateRoute: NavigationUtils.generateRoute,
      routes: {
        '/login': (context) => new Login(),
        '/emailVerify': (context) => new EmailVerify(),
        '/signUp': (context) => new SignUp(),
        '/homePage': (context) => new HomePage(),
        '/searchPage': (context) => new SearchPage(),
        '/themes': (context) => new Themes(),
        '/users': (context) => new Users(),
        '/profile': (context) => new ProfilePage(),
        '/chatList': (context) => new ConversationPageList(),
        '/chats': (context) => new ConversationPage(),
      },
    );
  }
}