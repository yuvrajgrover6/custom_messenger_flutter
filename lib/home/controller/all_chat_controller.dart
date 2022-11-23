import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_messenger/auth/controller/auth_controller.dart';
import 'package:custom_messenger/auth/models/user_model.dart';
import 'package:custom_messenger/contact/controller/contact_controller.dart';
import 'package:custom_messenger/home/model/chat.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart' as intl;

class AllChatController extends GetxController {
  AuthController authController = Get.find();

  AllChatController();

  @override
  void onInit() async {
    await getChattedUsers();
    super.onInit();
  }

  List<UserModel>? users = [];
  List<UserModelPlusChat>? chats = [];

  Future<void> getChattedUsers() async {
    final myChats = await FirebaseFirestore.instance
        .collection('users')
        .doc(authController.myUser.value!.mobileNumber)
        .collection('chats')
        .get();
    final List<String> myChatsId = myChats.docs.map((doc) => doc.id).toList();
    final allFirebaseUsers =
        await FirebaseFirestore.instance.collection('users').get();
    final allData = allFirebaseUsers.docs.map((doc) => doc.data()).toList();
    final tempUsers = allData.map((e) => UserModel.fromMap(e)).toList();
    users = tempUsers
        .where((element) =>
            element.uid != authController.myUser.value!.uid &&
            myChatsId.contains(element.mobileNumber))
        .toList();

    final List<Chat> myChatsData =
        myChats.docs.map((doc) => Chat.fromMap(doc.data())).toList();
    final myUsers = users;
    if (myUsers != null) {
      for (int i = 0; i < myUsers.length; i++) {
        final temp = UserModelPlusChat(myUsers[i], myChatsData[i]);
        chats?.add(temp);
      }
    }
    update();
  }

  String getMessageDate(Timestamp timestamp) {
    intl.DateFormat('dd/MM/yy').format(timestamp.toDate());
    if (intl.DateFormat('dd/MM/yy').format(timestamp.toDate()) ==
        intl.DateFormat('dd/MM/yy').format(DateTime.now())) {
      return "Today";
    } else {
      return intl.DateFormat('dd/MM/yy').format(timestamp.toDate());
    }
  }
}
