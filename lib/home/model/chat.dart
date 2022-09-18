// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_messenger/auth/models/user_model.dart';

class Chat {
  final String reciever;
  final String lastSend;
  final Timestamp lastSeenTime;
  Chat(this.reciever, this.lastSend, this.lastSeenTime);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'reciever': reciever,
      'lastSend': lastSend,
      'lastSeenTime': lastSeenTime
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(map['reciever'] as String, map['lastSend'] as String,
        map['lastSeenTime']);
  }

  String toJson() => json.encode(toMap());

  factory Chat.fromJson(String source) =>
      Chat.fromMap(json.decode(source) as Map<String, dynamic>);
}

class UserModelPlusChat {
  final UserModel user;
  final Chat chat;

  UserModelPlusChat(this.user, this.chat);
}
