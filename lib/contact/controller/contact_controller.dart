import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_messenger/auth/controller/auth_controller.dart';
import 'package:custom_messenger/auth/models/user_model.dart';
import 'package:custom_messenger/chat/controller/chat_view_controller.dart';
import 'package:custom_messenger/chat/views/chat_view.dart';
import 'package:custom_messenger/home/controller/all_chat_controller.dart';
import 'package:custom_messenger/home/model/chat.dart';
import 'package:get/get.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:hive/hive.dart';

import '../../home/model/chat_message.dart';

class ContactController extends GetxController {
  List<Contact>? contacts = [];
  List<UserModel>? matchedContacts = [];
  bool isLoading = false;
  final AuthController authController = Get.find();
  List<UserModel>? users = [];
  Rx<List<UserModel>>? nonMatchedContacts = Rx([]);

  @override
  onInit() async {
    super.onInit();
  }

  Future getLocalContacts() async {
    var box = await Hive.openBox('matchedContacts');
    List<dynamic>? getContacts = await box.get('contacts');
    if (getContacts?.isNotEmpty ?? false) {
      matchedContacts = getContacts!.cast<UserModel>();
      update();
    } else {
      await matchContact();
    }
  }

  Future<void> getContacts() async {
    if (await FlutterContacts.requestPermission()) {
      contacts = await FlutterContacts.getContacts(
          withProperties: true, deduplicateProperties: true);
      update();
    }
  }

  getMarker() async {
    final firebaseUsers =
        await FirebaseFirestore.instance.collection('users').get();
    final allData = firebaseUsers.docs.map((doc) => doc.data()).toList();
    users = allData.map((e) => UserModel.fromMap(e)).toList();
    update();
  }

  Future<void> matchContact() async {
    matchedContacts!.clear();
    var box = await Hive.openBox('matchedContacts');
    await box.delete('contacts');
    await box.clear();
    isLoading = true;
    update();
    await getMarker();
    for (var contact in contacts!) {
      for (var user in users!) {
        if (contact.phones.isNotEmpty &&
            contact.phones[0].normalizedNumber.isNotEmpty) {
          if (contact.phones[0].normalizedNumber == user.mobileNumber) {
            matchedContacts!.add(user);
          }
        }
      }
    }
    update();
    if (matchedContacts!.isNotEmpty) {
      var box = await Hive.openBox('matchedContacts');
      await box.put('contacts', matchedContacts);
    }
    isLoading = false;
    update();
  }

  Future<void> checkforNonChatedNumbers() async {
    isLoading = true;
    nonMatchedContacts!.value.clear();
    DocumentSnapshot? result;
    for (var contact in matchedContacts!) {
      result = (await FirebaseFirestore.instance
          .collection('users')
          .doc(authController.myUser.value!.mobileNumber)
          .collection('chats')
          .doc(contact.mobileNumber.toString())
          .get());
    }
    if (result == null) {
      nonMatchedContacts!.value = matchedContacts!;
    }
    if (result != null) {
      if (result.data() != null) {
        nonMatchedContacts!.value = matchedContacts!
            .where((element) => element.mobileNumber != result!.id)
            .toList();
        isLoading = false;
        update();
      } else {
        nonMatchedContacts!.value = matchedContacts!;
        isLoading = false;
        update();
      }
    }
  }

  void onPress(UserModel user) async {
    final UserModelPlusChat demoMessage = UserModelPlusChat(
        user, Chat(user.mobileNumber, 'Hello', Timestamp.now()));

    await FirebaseFirestore.instance
        .collection('users')
        .doc(authController.myUser.value!.mobileNumber)
        .collection('chats')
        .doc(user.mobileNumber)
        .set(demoMessage.chat.toMap());
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.mobileNumber)
        .collection('chats')
        .doc(authController.myUser.value!.mobileNumber)
        .set(demoMessage.chat.toMap());

    final chates = await Future.wait((await FirebaseFirestore.instance
            .collection('users')
            .doc(authController.myUser.value!.mobileNumber)
            .collection('chats')
            .get())
        .docs
        .map((chatdoc) => Chat.fromMap(chatdoc.data()))
        .toList()
        .map((chat) async =>
            UserModelPlusChat(authController.myUser.value!, chat)));
    Get.to(ChatView(), binding: BindingsBuilder(() {
      Get.lazyPut<ChatViewController>(() => ChatViewController(chates[0]));
    }));
  }
}
