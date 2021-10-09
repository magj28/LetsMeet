//used for storing data of user fetched from database
class User {
  String userID;
  String firstName;
  String lastName;
  String userName;
  String email;

  User(
      {required this.userID,
      required this.firstName,
      required this.lastName,
      required this.userName,
      required this.email});

  factory User.fromJson(Map<dynamic, dynamic> json) {
    return User(
        userID: json['_id'],
        firstName: json['First Name'],
        lastName: json['Last Name'],
        userName: json['Username'],
        email: json['Email']);
  }
}
