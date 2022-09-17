import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_messenger/auth/controller/auth_controller.dart';
import 'package:custom_messenger/auth/models/user_model.dart';
import 'package:custom_messenger/contact/controller/contact_controller.dart';
import 'package:custom_messenger/home/model/chat.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:get/get.dart';

class AllChatController extends GetxController with StateMixin<List<Chat>> {
  ContactController contactController = Get.find();
  AuthController authController = Get.find();

  AllChatController();

  @override
  void onInit() async {
    change(await getChatsWith(contactController.matchedContacts),
        status: RxStatus.success());
    super.onInit();
  }

  Future<List<Chat>> getChatsWith(List<UserModel>? matchedContacts) async {
    if (matchedContacts != null) {
      return await Future.wait(matchedContacts.map((e) async {
        final sortednums = ([
          authController.myUser.value!.mobileNumber,
          e.mobileNumber
        ]..sort(((a, b) {
            return a.compareTo(b);
          })));
        final path = sortednums.fold(
            "", (String previousValue, element) => previousValue + element);
        return Chat.fromMap((await FirebaseFirestore.instance
            .collection('chatRooms')
            .doc(path)
            .get()) as Map<String, dynamic>);
      }));
    } else {
      return [];
    }
  }
}
