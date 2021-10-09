//model to store channel and user details when requesting for call
class ResCallRequestModel {
  String? id;
  String? channel;
  String? token;
  String? firstName;
  String? lastName;

  ResCallRequestModel(
      {this.id, this.channel, this.token, this.firstName, this.lastName});

  ResCallRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    channel = json['channel'];
    token = json['token'];
    firstName = json['firstName'];
    lastName = json['lastName'];
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'channel': channel,
        'token': token,
      };
}
