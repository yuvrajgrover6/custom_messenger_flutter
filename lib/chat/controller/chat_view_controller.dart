import 'dart:io';
import 'dart:typed_data';
import 'package:advance_image_picker/advance_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_messenger/auth/controller/auth_controller.dart';
import 'package:custom_messenger/auth/models/user_model.dart';
import 'package:custom_messenger/contact/controller/contact_controller.dart';
import 'package:custom_messenger/home/model/chat.dart';
import 'package:custom_messenger/home/model/chat_message.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatViewController extends GetxController
    with StateMixin<Set<ChatMessage>> {
  Rx<bool> isEmojiVisible = true.obs;
  FocusNode focusNode = FocusNode();
  TextEditingController msgController = TextEditingController();
  List imageFiles = [];
  Uint8List? bytes;
  List bothNumbers = [];
  final AuthController authController = Get.find();

  ChatViewController(this.chats);
  @override
  void onInit() async {
    change(await getChatsWith(), status: RxStatus.success());
    await setStatusRead();
    super.onInit();

    final configs = ImagePickerConfigs();
    // AppBar text color
    configs.appBarTextColor = Colors.white;
    configs.appBarBackgroundColor = Colors.blue;
    configs.translateFunc = (name, value) {
      switch (name) {
        case 'image_picker_select_images_title':
          return 'Selected images count';
        case 'image_picker_select_images_guide':
          return 'You can drag images for sorting list...';
        case 'image_picker_camera_title':
          return 'Camera';
        case 'image_picker_album_title':
          return 'Album';
        case '"image_picker_select_button_title"':
          return 'Send';
        default:
          return value;
      }
    };
    focusNode.addListener(() {
      if (focusNode.hasFocus || focusNode.hasPrimaryFocus) {
        isEmojiVisible.value = !isEmojiVisible.value;
        update();
      }
    });
    super.onInit();
  }

  @override
  void dispose() {
    focusNode.unfocus();
    msgController.clear();
    super.dispose();
  }

  Future pickImage(BuildContext context) async {
    List<ImageObject> objects = await Navigator.of(context)
        .push(PageRouteBuilder(pageBuilder: (context, animation, __) {
      return const ImagePicker(maxCount: 5);
    }));

    if (objects.isNotEmpty) {
      imageFiles.addAll(objects.map((e) => e.modifiedPath).toList());
      getPhoto();
    }
  }

  Future<Uint8List?> getPhoto() async {
    if (imageFiles.isNotEmpty) {
      bytes = await File(imageFiles[0]).readAsBytes();
      update();
    }
    return bytes;
  }

  sendMsg(
    UserModel user,
  ) async {
    final ChatMessage msgModel = ChatMessage(
        msg: msgController.text,
        time: Timestamp.fromDate(DateTime.now()),
        type: "msg",
        status: Status.unread,
        sender: authController.myUser.value!.mobileNumber);
    try {
      
      await FirebaseFirestore.instance
          .collection('users')
          .doc(authController.currentUser!.displayName)
          .collection('chats')
          .doc(user.mobileNumber)
          .collection('messages')
          .add(msgModel.toMap())
          .then((doc) {
        msgController.clear();
        change(value?..add(msgModel), status: RxStatus.success());
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.mobileNumber)
          .collection('chats')
          .doc(authController.myUser.value!.mobileNumber)
          .collection('messages')
          .add(msgModel.toMap());
      await FirebaseFirestore.instance
          .collection('users')
          .doc(authController.myUser.value!.mobileNumber)
          .collection('chats')
          .doc(user.mobileNumber)
          .set(Chat(user.mobileNumber, msgModel.msg, msgModel.time).toMap());
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.mobileNumber)
          .collection('chats')
          .doc(authController.myUser.value!.mobileNumber)
          .set(Chat(user.mobileNumber, msgModel.msg, msgModel.time).toMap());
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  ContactController contactController = Get.find();

  final UserModelPlusChat chats;
  DocumentSnapshot? lastLoadedDoc;
  Future<Set<ChatMessage>> getChatsWith() async {
    final List<QueryDocumentSnapshot<Map<String, dynamic>>> result;
    if (lastLoadedDoc != null) {
      result = (await FirebaseFirestore.instance
              .collection('users')
              .doc(authController.myUser.value!.mobileNumber)
              .collection('chats')
              .doc(chats.chat.reciever)
              .collection('messages')
              .orderBy('time')
              .startAfterDocument(lastLoadedDoc!)
              .limit(50)
              .get())
          .docs;
      lastLoadedDoc = result.last;
    } else {
      result = (await FirebaseFirestore.instance
              .collection('users')
              .doc(authController.myUser.value!.mobileNumber)
              .collection('chats')
              .doc(chats.chat.reciever)
              .collection('messages')
              .orderBy('time')
              .limit(50)
              .get())
          .docs;
    }
    return result
        .map<ChatMessage>((e) => ChatMessage.fromMap(e.data()))
        .toSet();
  }

  String getTime(Timestamp timestamp) {
    if (timestamp.toDate().minute < 10) {
      return '${timestamp.toDate().hour}:0${timestamp.toDate().minute}';
    } else {
      return '${timestamp.toDate().hour}:${timestamp.toDate().minute}';
    }
  }

  Future<void> setStatusRead() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(authController.myUser.value!.mobileNumber)
        .collection('chats')
        .doc(chats.chat.reciever)
        .collection('messages')
        .where('sender',
            isNotEqualTo: authController.myUser.value!.mobileNumber)
        .get()
        .then((value) {
      for (var element in value.docs) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(authController.myUser.value!.mobileNumber)
            .collection('chats')
            .doc(chats.chat.reciever)
            .collection('messages')
            .doc(element.id)
            .update({'status': 'read'});
      }
    });
  }
}
