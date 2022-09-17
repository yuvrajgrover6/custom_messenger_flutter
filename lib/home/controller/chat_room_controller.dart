import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_messenger/auth/controller/auth_controller.dart';
import 'package:custom_messenger/auth/models/user_model.dart';
import 'package:custom_messenger/contact/controller/contact_controller.dart';
import 'package:custom_messenger/home/model/chat.dart';
import 'package:custom_messenger/home/model/chat_message.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:get/get.dart';

class ChatRoomController extends GetxController with StateMixin<ChatMessage> {
  ContactController contactController = Get.find();
  AuthController authController = Get.find();

  final Chat chats;
  late List<ChatMessage> chatmessages; // TODO: dlete this do with state mixin
  DocumentSnapshot? lastLoadedDoc;

  ChatRoomController(this.chats);

  @override
  void onInit() async {
    chatmessages = await getChatsWith();
    super.onInit();
  }

  Future<List<ChatMessage>> getChatsWith() async {
    final sortednums = ([chats.sender, chats.reciever]..sort(((a, b) {
        return a.compareTo(b);
      })));
    final path = sortednums.fold(
        "", (String previousValue, element) => previousValue + element);
    final List<QueryDocumentSnapshot<Map<String, dynamic>>> result;
    if (lastLoadedDoc != null) {
      result = (await FirebaseFirestore.instance
              .collection('chatRooms')
              .doc(path)
              .collection('chats')
              .startAfterDocument(lastLoadedDoc!)
              .limit(50)
              .get())
          .docs;
      lastLoadedDoc = result.last;
    } else {
      result = (await FirebaseFirestore.instance
              .collection('chatRooms')
              .doc(path)
              .collection('chats')
              .limit(50)
              .get())
          .docs;
    }
    return result
        .map<ChatMessage>((e) => ChatMessage.fromMap(e.data()))
        .toList();
  }
}
