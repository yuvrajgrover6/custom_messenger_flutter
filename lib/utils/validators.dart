import 'package:get/get.dart';

String? validatePassword(String? password) {
  if (password!.isEmpty) {
    return "Password Can't be Empty";
  }
  if ((password.trim().length) < 6) {
    return "Password Can't be less than 6";
  }

  return null;
}

String? validateEmail(String? email) {
  if (!GetUtils.isEmail(email?.trim() ?? "")) {
    return "Provide valid Email";
  }

  return null;
}