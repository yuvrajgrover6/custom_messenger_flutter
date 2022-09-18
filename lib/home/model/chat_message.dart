// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

enum Status {
  unread,
  read,
}

class ChatMessage {
  final String msg;
  final String type;
  final Timestamp time;
  final Status status;

  ChatMessage(
      {required this.msg,
      required this.type,
      required this.time,
      required this.status});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'msg': msg,
      'type': type,
      'time': time,
      'status': status.name,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
        msg: map['msg'] as String,
        type: map['type'] as String,
        time: map['time'],
        status: Status.values.byName(map['status']));
  }

  String toJson() => json.encode(toMap());

  factory ChatMessage.fromJson(String source) =>
      ChatMessage.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  // TODO: implement hashCode
  int get hashCode =>
      msg.hashCode ^ type.hashCode ^ time.hashCode ^ status.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is! ChatMessage) return false;
    return msg == other.msg &&
        type == other.type &&
        time == other.time &&
        status == other.status;
  }
}
