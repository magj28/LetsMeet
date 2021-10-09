//model to store each chat message and its details
class Chat {
  String senderID;
  String message;
  String date;

  Chat({required this.senderID, required this.message, required this.date});

  factory Chat.fromJson(Map<dynamic, dynamic> json) {
    return Chat(
        senderID: json['senderID'],
        message: json['message'],
        date: json['Date']);
  }
}

//model to store all chats between 2 users
class AllChats {
  String? user1ID;
  String? user2ID;
  List<Chat>? chats;

  AllChats({required this.user1ID, required this.user2ID, this.chats});

  factory AllChats.fromJson(Map<dynamic, dynamic> json) {
    var list = json['Chats'] as List;
    List<Chat> chatList = list.map((i) => Chat.fromJson(i)).toList();

    return AllChats(
        user1ID: json['user1ID'], user2ID: json['user2ID'], chats: chatList);
  }
}
