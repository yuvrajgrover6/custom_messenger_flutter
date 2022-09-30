import 'package:custom_messenger/auth/models/user_model.dart';
import 'package:custom_messenger/auth/view/login.dart';
import 'package:custom_messenger/contact/controller/contact_controller.dart';
import 'package:custom_messenger/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'auth/controller/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
  await Hive.initFlutter();
  Hive.registerAdapter(UserModelAdapter());

}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: BindingsBuilder(() {
        Get.put(AuthController(), permanent: true);
      }),
      debugShowCheckedModeBanner: false,
      title: 'Custom Messenger',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Login(),
    );
  }
}
