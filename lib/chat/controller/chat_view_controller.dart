import 'dart:io';
import 'dart:typed_data';
import 'package:advance_image_picker/advance_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_messenger/auth/controller/auth_controller.dart';
import 'package:custom_messenger/auth/models/user_model.dart';
import 'package:custom_messenger/contact/controller/contact_controller.dart';
import 'package:custom_messenger/home/model/chat.dart';
import 'package:custom_messenger/home/model/chat_message.dart';
import 'package:custom_messenger/home/views/homepage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class ChatViewController extends GetxController
    with StateMixin<List<ChatMessage>> {
  bool isDeleting = false;
  bool isSending = false;
  Rx<bool> isEmojiVisible = true.obs;
  FocusNode focusNode = FocusNode();
  TextEditingController msgController = TextEditingController();
  List imageFiles = [];
  Uint8List? bytes;
  List bothNumbers = [];
  final AuthController authController = Get.find();
  RxList<String> allChatDocIds = <String>[].obs;
  // final ScrollController controller = ScrollController();

  ChatViewController(this.chats);

  @override
  void onInit() async {
    await getChatsWith();
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
    msgController.text = '';
    try {
      isSending = true;
      update();
      change(value?..add(msgModel), status: RxStatus.success());
      await FirebaseFirestore.instance
          .collection('users')
          .doc(authController.currentUser!.displayName)
          .collection('chats')
          .doc(user.mobileNumber)
          .collection('messages')
          .add(msgModel.toMap())
          .then((doc) {
        msgController.clear();
      }).onError((error, stackTrace) {
        change(value?..remove(msgModel), status: RxStatus.success());
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
          .set(Chat(authController.myUser.value!.mobileNumber, msgModel.msg,
                  msgModel.time)
              .toMap());
      msgController.clear();
      await FlutterRingtonePlayer.play(fromAsset: 'assets/sounds/sent.mp3');
      isSending = false;
      update();
      // await controller.position.moveTo(controller.position.maxScrollExtent);
    } catch (e) {
      Get.snackbar('Error', e.toString());
      msgController.clear();
      isSending = false;
      update();
    } finally {
      msgController.clear();
    }
  }

  Future<void> deleteMsg(
      {required String docId, required String receiver}) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(authController.currentUser!.displayName)
        .collection('chats')
        .doc(receiver)
        .collection('messages')
        .doc(docId)
        .update({'msg': 'This message was deleted'});
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiver)
        .collection('chats')
        .doc(authController.currentUser!.displayName)
        .collection('messages')
        .doc(docId)
        .update({'msg': 'This message was deleted'});
  }

  Future<void> deleteChat({required String receiver}) async {
    isDeleting = true;
    update();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(authController.currentUser!.displayName)
        .collection('chats')
        .doc(receiver)
        .collection('messages')
        .get()
        .then((value) {
      for (DocumentSnapshot ds in value.docs) {
        ds.reference.delete();
      }
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(receiver)
        .collection('chats')
        .doc(authController.currentUser!.displayName)
        .collection('messages')
        .get()
        .then((value) {
      for (DocumentSnapshot ds in value.docs) {
        ds.reference.delete();
      }
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(receiver)
        .collection('chats')
        .doc(authController.currentUser!.displayName)
        .delete();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(authController.currentUser!.displayName)
        .collection('chats')
        .doc(receiver)
        .delete();

    Get.offAll(const HomePage());
    isDeleting = false;
  }

  ContactController contactController = Get.find();

  final UserModelPlusChat chats;
  DocumentSnapshot? lastLoadedDoc;
  Future<void> getChatsWith() async {
    final List<QueryDocumentSnapshot<Map<String, dynamic>>> result;

    final query = await (FirebaseFirestore.instance
        .collection('users')
        .doc(chats.chat.reciever)
        .collection('chats')
        .doc(authController.myUser.value!.mobileNumber)
        .collection('messages')
        .orderBy('time')
        .get());

    change(query.docs.map((e) => ChatMessage.fromMap(e.data())).toList(),
        status: RxStatus.success());
    (FirebaseFirestore.instance
        .collection('users')
        .doc(chats.chat.reciever)
        .collection('chats')
        .doc(authController.myUser.value!.mobileNumber)
        .collection('messages')
        .orderBy('time')
        .snapshots()
        .listen((event) {
      if (event.docs.last.data()['sender'] !=
          authController.myUser.value!.mobileNumber) {
        FlutterRingtonePlayer.play(fromAsset: 'assets/sounds/receive.mp3');
      }
      final allChat =
          event.docs.map((e) => ChatMessage.fromMap(e.data())).toList();
      change(allChat, status: RxStatus.success());
      allChatDocIds.value = event.docs.map((e) => e.id).toList();

      if (allChat.any((element) => element.status == Status.unread)) {
        setStatusRead();
      }

      // final newChats =
      //     listNewDocs.map((e) => ChatMessage.fromMap(e.doc.data()!));
      // for (var i = 0; i < (value?.length ?? 0); i++) {
      //   final old = value![i];
      //   newChats.forEach((newElement) {
      //     if (newElement.time == old.time) {
      //       value!.replaceRange(i, i + 1, [newElement]);
      //     }
      //     else {

      //     }
      //   });
      // }
    }));
    // .docs;
    //   lastLoadedDoc = result.last;
    // } else {
    //   result = (await FirebaseFirestore.instance
    //           .collection('users')
    //           .doc(authController.myUser.value!.mobileNumber)
    //           .collection('chats')
    //           .doc(chats.chat.reciever)
    //           .collection('messages')
    //           .orderBy('time')
    //           .limit(50)
    //           .get())
    //       .docs;
    // }
    // return result
    //     .map<ChatMessage>((e) => ChatMessage.fromMap(e.data()))
    //     .toSet();

    // await controller.position.moveTo(controller.position.maxScrollExtent);
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
        element.reference.update({'status': 'read'});
      }
    });
  }
}
