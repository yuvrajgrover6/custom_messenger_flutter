import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_messenger/auth/controller/auth_controller.dart';
import 'package:custom_messenger/auth/models/user_model.dart';
import 'package:custom_messenger/contact/controller/contact_controller.dart';
import 'package:custom_messenger/home/model/chat.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:get/get.dart';

class AllChatController extends GetxController
    with StateMixin<List<UserModelPlusChat>> {
  ContactController contactController = Get.find();
  AuthController authController = Get.find();

  AllChatController();

  @override
  void onInit() async {
    change(await getChatsWith(contactController.matchedContacts),
        status: RxStatus.success());
    super.onInit();
  }

  Future<List<UserModelPlusChat>> getChatsWith(
      List<UserModel>? matchedContacts) async {
    return await Future.wait((await FirebaseFirestore.instance
            .collection('users')
            .doc(authController.myUser.value!.mobileNumber)
            .collection('chats')
            .get())
        .docs
        .map((chatdoc) => Chat.fromMap(chatdoc.data()))
        .toList()
        .map((chat) async => UserModelPlusChat(
            UserModel.fromMap((await FirebaseFirestore.instance
                    .collection('users')
                    .doc(authController.myUser.value!.mobileNumber)
                    .get())
                .data() as Map<String, dynamic>),
            chat)));
  }
}
