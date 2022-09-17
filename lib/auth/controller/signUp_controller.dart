import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:advance_image_picker/configs/image_picker_configs.dart';
import 'package:advance_image_picker/models/image_object.dart';
import 'package:advance_image_picker/widgets/picker/image_picker.dart';
import 'package:custom_messenger/auth/controller/auth_controller.dart';
import 'package:custom_messenger/auth/view/profile_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  AuthController authController = Get.find();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  GlobalKey<FormState> signUpKey = GlobalKey<FormState>();
  GlobalKey<FormState> nextKey = GlobalKey<FormState>();
  String pfp = "";
  List imageFiles = [];
  Uint8List? bytes;
  bool nextLoading = false;
  bool submitLoading = false;

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
        default:
          return value;
      }
    };
    super.onInit();
  }

  Future signUp() async {
    if (signUpKey.currentState!.validate()) {
      if (bytes != null) {
        submitLoading = true;
        update();
        Future.delayed(const Duration(seconds: 5), () {
          submitLoading = false;
          update();
        });
        await authController.emailSignUp(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
            name: nameController.text.trim(),
            mobileNumber: mobileController.text.trim(),
            bytes: bytes!);
        update();
      } else {
        Get.snackbar("", 'please select image');
        return;
      }
    } else {
      return;
    }
  }

  Future next() async {
    if (nextKey.currentState!.validate()) {
      nextLoading = true;
      update();
      await Get.to(() => const CreateProfile());
      nextLoading = false;
      update();
    } else {
      print('error');
    }
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
}
