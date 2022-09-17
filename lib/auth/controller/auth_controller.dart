import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_messenger/auth/models/user_model.dart';
import 'package:custom_messenger/auth/view/login.dart';
import 'package:custom_messenger/home/views/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final Rx<User?> _currentUser = FirebaseAuth.instance.currentUser.obs;
  User? get currentUser => _currentUser.value;
  bool isLoggedIn = false;
  Rx<UserModel?> myUser = Rx(null);
  UserModel? get getUser => myUser.value;
  String? profilePicUrl;
  @override
  void onReady() {
    _currentUser.bindStream(FirebaseAuth.instance.userChanges());
    final a = ever(_currentUser, setInitialScreen);
    super.onReady();
  }

  setInitialScreen(User? user) async {
    try {
      if (user != null) {
        if (!isLoggedIn) {
          final userSnap = await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
          if (userSnap.exists) {
            myUser.value =
                UserModel.fromMap(userSnap.data() as Map<String, dynamic>);
            Get.off(() => const HomePage());
          } else {
            Get.snackbar('Failure', 'User Data doesnot exist',
                colorText: Colors.white, backgroundColor: Colors.red);
          }
        }
      } else {
        //if user does not exist
        Get.offAll(() => const Login());
        isLoggedIn = false;
      }
    } on FirebaseAuthException {
      Get.snackbar('Failure', 'User doesnot exist',
          colorText: Colors.white, backgroundColor: Colors.red);
      Get.offAll(() => const Login());
      isLoggedIn = false;
    }
  }

  Future emailLogin({required String email, required String password}) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      User user = userCredential.user!;
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar(
          'Error',
          'No user found for that email.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else if (e.code == 'wrong-password') {
        Get.snackbar('Error', 'Wrong password provided for that user.',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    }
  }

  Future signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      isLoggedIn = false;
      update();
    } on FirebaseAuthException catch (e) {
      throw Exception(e);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future uploadImageDb({required bytes}) async {
    Reference reference =
        FirebaseStorage.instance.ref().child('${currentUser!.uid}/pfp');
    await reference.putData(bytes!);
    profilePicUrl = await reference.getDownloadURL();
    update();
  }

  Future emailSignUp(
      {required String email,
      required String password,
      required String name,
      required Uint8List bytes,
      required String mobileNumber}) async {
    try {
      UserCredential usrCrd = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await uploadImageDb(bytes: bytes);
      update();
      UserModel userModel = UserModel(
          email: email,
          name: name,
          uid: usrCrd.user!.uid,
          profilePicUrl: profilePicUrl!,
          mobileNumber: mobileNumber);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(usrCrd.user!.uid)
          .set(userModel.toMap());

      Get.snackbar('Account Created Successfully', 'Login to continue',
          backgroundColor: Colors.green, colorText: Colors.white);
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message.toString(),
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}
