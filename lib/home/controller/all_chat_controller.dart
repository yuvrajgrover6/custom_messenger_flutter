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
    users?.bindStream(userModels());
    usersAndChats?.bindStream(getChats(usersList!));
    super.onInit();
  }

  Rx<List<UserModel>>? users = Rx<List<UserModel>>([]);
  List<UserModel>? get usersList => users?.value;
  Rx<List<UserModelPlusChat>>? usersAndChats = Rx<List<UserModelPlusChat>>([]);
  List<UserModelPlusChat>? get usersAndChatsList => usersAndChats?.value;

  Stream<List<UserModel>> userModels() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(authController.myUser.value!.mobileNumber)
        .collection('chats')
        .snapshots()
        .map((QuerySnapshot query) {
      List<UserModel> users = [];
      for (var doc in query.docs) {
        if (doc.data() != null) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(doc.id)
              .get()
              .then((value) {
            users.add(UserModel.fromMap(value.data()!));
          });
        }
      }
      return users;
    });
  }

  Stream<List<UserModelPlusChat>> getChats(List<UserModel> users) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(authController.myUser.value!.mobileNumber)
        .collection('chats')
        .snapshots()
        .map((QuerySnapshot query) {
      List<UserModelPlusChat> users = [];
      for (var doc in query.docs) {
        if (doc.data() != null) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(doc.id)
              .get()
              .then((value) {
            users.add(UserModelPlusChat(UserModel.fromMap(value.data()!),
                Chat.fromMap(doc.data() as Map<String, dynamic>)));
          });
        }
      }
      return users;
    });
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
