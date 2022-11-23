import 'package:custom_messenger/auth/models/user_model.dart';
import 'package:custom_messenger/auth/view/login.dart';
import 'package:custom_messenger/call/controller/theme_controller.dart';
import 'package:custom_messenger/contact/controller/contact_controller.dart';
import 'package:custom_messenger/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'auth/controller/auth_controller.dart';
import 'call/controller/local_db_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());
  await Get.putAsync(() async {
    final controller = LocalDBController();
    await controller.intializeLocalDB();
    return controller;
  }, permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: BindingsBuilder(() async {
        Get.put(ThemeController(), permanent: true);
        Get.put(AuthController(), permanent: true);
      }),
      debugShowCheckedModeBanner: false,
      title: 'Custom Messenger',
      theme: ThemeController().primaryTheme(),
      home: const Login(),
    );
  }
}
