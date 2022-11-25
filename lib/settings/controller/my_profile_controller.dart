import 'dart:io';
import 'dart:typed_data';

import 'package:advance_image_picker/advance_image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../auth/controller/auth_controller.dart';

class MyProfileController extends GetxController {
  final AuthController controller = Get.find();
  bool loading = false;
  toggleLoading() {
    loading = !loading;
    update();
  }

  List imageFiles = [];
  String? name;
  String? pfpUrl;
  Uint8List? bytes;
  TextEditingController nameController = TextEditingController();

  final primaryColor = Theme.of(Get.context!).colorScheme.primary;
  final secondaryColor = Theme.of(Get.context!).colorScheme.secondary;
  void onInit() async {
    final configs = ImagePickerConfigs();
    // AppBar text color
    configs.appBarTextColor = secondaryColor;
    configs.appBarBackgroundColor = primaryColor;
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
        default:
          return value;
      }
    };
    final result1 = await FirebaseFirestore.instance
        .collection("users")
        .doc(controller.myUser.value?.mobileNumber)
        .get();
    name = result1.data()?["name"] ?? "";
    update();
    final result2 = await FirebaseFirestore.instance
        .collection("users")
        .doc(controller.myUser.value?.mobileNumber)
        .get();
    pfpUrl = result2.data()?["profilePicUrl"] ?? "";
    update();
    super.onInit();
  }

  Future getPfp() async {
    if (imageFiles.isNotEmpty) {
      bytes = await File(imageFiles[0]).readAsBytes();
      update();
    }
    return bytes;
  }

  Future pickImage(BuildContext context) async {
    List<ImageObject> objects = await Navigator.of(context)
        .push(PageRouteBuilder(pageBuilder: (context, animation, __) {
      return const ImagePicker(maxCount: 1);
    }));

    if (objects.isNotEmpty) {
      imageFiles.addAll(objects.map((e) => e.modifiedPath).toList());
      getPfp();
    }
  }

  Future<void> updateProfile() async {
    if ((nameController.text.isNotEmpty &&
            nameController.text != controller.myUser.value!.name) ||
        bytes != null) {
      try {
        toggleLoading();
        String? url = "";
        if (bytes != null) {
          url = await uploadProfilePic();
        }
        if (url != "") {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(controller.myUser.value!.mobileNumber)
              .update({
            "name": nameController.text,
            "profilePicUrl": url,
          });
          Get.snackbar("Profile Updated", "Profile Updated Successfully",
              backgroundColor: Colors.green, colorText: Colors.white);
          toggleLoading();
        } else {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(controller.myUser.value!.mobileNumber)
              .update({
            "name": nameController.text,
          });
          Get.snackbar("Profile Updated", "Profile Updated Successfully",
              backgroundColor: Colors.green, colorText: Colors.white);
          toggleLoading();
        }
      } catch (e) {
        Get.snackbar("Error", e.toString());
        toggleLoading();
      }
    } else {
      Get.snackbar('Error', 'Please edit your name or update profile picture',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  Future<String> uploadProfilePic() async {
    if (bytes != null) {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref =
          storage.ref().child('${controller.myUser.value!.uid}/pfp.jpeg');
      UploadTask uploadTask = ref.putData(bytes!);
      TaskSnapshot taskSnapshot = await uploadTask;
      String url = await taskSnapshot.ref.getDownloadURL();
      return url;
    }
    return '';
  }
}
