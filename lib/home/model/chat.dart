// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Chat {
  final String sender;
  final String reciever;

  Chat(this.sender, this.reciever);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'sender': sender,
      'reciever': reciever,
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      map['sender'] as String,
      map['reciever'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Chat.fromJson(String source) => Chat.fromMap(json.decode(source) as Map<String, dynamic>);
}
