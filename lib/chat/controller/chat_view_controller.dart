import 'dart:io';
import 'dart:typed_data';
import 'package:advance_image_picker/advance_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_messenger/auth/controller/auth_controller.dart';
import 'package:custom_messenger/auth/models/user_model.dart';
import 'package:custom_messenger/chat/model/msg_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatViewController extends GetxController {
  Rx<bool> isEmojiVisible = true.obs;
  FocusNode focusNode = FocusNode();
  TextEditingController msgController = TextEditingController();
  List imageFiles = [];
  Uint8List? bytes;
  List bothNumbers = [];
  final AuthController authController = Get.find();
  @override
  void onInit() {
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

  sendMsg(UserModel user) async {
    final MsgModel msgModel = MsgModel(
        msg: msgController.text,
        sender: authController.myUser.value!.mobileNumber,
        receiver: user.mobileNumber,
        time: DateTime.now(),
        type: "msg",
        isRead: false);
    List list = [msgModel.sender, msgModel.receiver];
    list.sort((a, b) => a.compareTo(b));
    bothNumbers = list;
    try {
      await FirebaseFirestore.instance
          .collection('chatRooms')
          .doc(bothNumbers[0] + bothNumbers[1])
          .collection('chats')
          .add(msgModel.toMap())
          .then((value) {
        msgController.clear();
        Get.snackbar('Success', 'messgae sent');
      });
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future getMessages(UserModel user) async {
    List list = [authController.myUser.value!.mobileNumber, user.mobileNumber];
    list.sort((a, b) => a.compareTo(b));
    bothNumbers = list;
    List<MsgModel> listOfMsgs = [];
    try {
      await FirebaseFirestore.instance
          .collection('chatRooms')
          .doc(bothNumbers[0] + bothNumbers[1])
          .collection('chats')
          .get()
          .then((value) {
        value.docs.forEach((element) {
          listOfMsgs.add(MsgModel.fromMap(element.data()));
        });
      });
      return listOfMsgs;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
