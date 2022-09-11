import 'dart:convert';

class UserModel {
  String name;
  String email;
  String uid;
  String profilePicUrl;
  String mobileNumber;
  UserModel(
      {required this.name,
      required this.email,
      required this.profilePicUrl,
      required this.uid,
      required this.mobileNumber});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'uid': uid,
      'profilePicUrl': profilePicUrl,
      'mobileNumber': mobileNumber
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        name: map['name'],
        email: map['email'],
        profilePicUrl: map['profilePicUrl'],
        uid: map['uid'],
        mobileNumber: map['mobileNumber']);
  }
  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
