import 'dart:convert';

class MsgModel {
  String msg;
  String sender;
  String receiver;
  DateTime time;
  String type;
  bool isRead;  
  MsgModel({
    required this.msg,
    required this.sender,
    required this.receiver,
    required this.time,
    required this.type,
    required this.isRead,
  });
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'msg': msg,
      'sender': sender,
      'receiver': receiver,
      'time': time,
      'type': type,
      'isRead': isRead,
    };
  }
  factory MsgModel.fromMap(Map<String, dynamic> map) {
    return MsgModel(
      msg: map['msg'],
      sender: map['sender'],
      receiver: map['receiver'],
      time: map['time'].toDate(),
      type: map['type'],
      isRead: map['isRead'],
    );
  }
  String toJson() => json.encode(toMap());
  factory MsgModel.fromJson(String source) =>
      MsgModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
