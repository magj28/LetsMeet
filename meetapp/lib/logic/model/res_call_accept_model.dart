//model to store channel details as well as users present in call
class ResCallAcceptModel {
  String? channel;
  String? token;
  String? id;
  String? otherUserId;

  ResCallAcceptModel({this.channel, this.token, this.id, this.otherUserId});

  ResCallAcceptModel.fromJson(Map<String, dynamic> json) {
    channel = json['channel'];
    token = json['token'];
    id = json['id'];
    otherUserId = json['otherUserId'];
  }

  Map<String, dynamic> toJson() => {
        'channel': channel,
        'token': token,
        'id': id,
        'otherUserId': otherUserId,
      };
}
