//used for storing arguments passed from video Call screen to users
class ScreenArguments {
  String? pageDirected;
  String? keyword;
  String? token;
  String? channel;

  ScreenArguments(
      String? pageDirected, String? keyword, String? token, String? channel)
      : pageDirected = pageDirected,
        token = token,
        channel = channel,
        keyword = keyword;
}

//used for storing arguments passed to chat screen
class ChatArguments {
  String? firstName;
  String? lastName;
  String? userName;
  String? userID;

  ChatArguments(
      String? firstName, String? lastName, String? userName, String? userID)
      : firstName = firstName,
        lastName = lastName,
        userName = userName,
        userID = userID;
}
