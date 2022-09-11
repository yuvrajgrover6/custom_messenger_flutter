import 'package:custom_messenger/auth/controller/auth_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  AuthController authController = Get.find();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future signIn() async {
    isLoading = true;
    update();
    await authController.emailLogin(
        email: emailController.text.trim(),
        password: passwordController.text.trim());
    isLoading = false;
    update();
  }
}
