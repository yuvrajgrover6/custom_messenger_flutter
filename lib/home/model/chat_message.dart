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

  ChatMessage(this.msg, this.type, this.time, this.status);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'msg': msg,
      'type': type,
      'time': time,
      'status': status.name,
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(map['msg'] as String, map['type'] as String, map['time'],
        Status.values.byName(map['status']));
  }

  String toJson() => json.encode(toMap());

  factory ChatMessage.fromJson(String source) =>
      ChatMessage.fromMap(json.decode(source) as Map<String, dynamic>);
}
