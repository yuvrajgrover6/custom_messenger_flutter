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
    final controller = Get.put<ThemeController>(ThemeController());
    return GetMaterialApp(
      initialBinding: BindingsBuilder(() async {
        Get.put(ThemeController(), permanent: true);
        Get.put(AuthController(), permanent: true);
      }),
      debugShowCheckedModeBanner: false,
      title: 'Custom Messenger',
      theme: ThemeData(
          textTheme: TextTheme(
            headline1:
                TextStyle(color: Color(int.parse(controller.secondaryColor))),
            headline2:
                TextStyle(color: Color(int.parse(controller.secondaryColor))),
            headline3:
                TextStyle(color: Color(int.parse(controller.secondaryColor))),
            headline4:
                TextStyle(color: Color(int.parse(controller.secondaryColor))),
            headline5:
                TextStyle(color: Color(int.parse(controller.secondaryColor))),
            headline6:
                TextStyle(color: Color(int.parse(controller.secondaryColor))),
            subtitle1:
                TextStyle(color: Color(int.parse(controller.secondaryColor))),
            subtitle2:
                TextStyle(color: Color(int.parse(controller.secondaryColor))),
            bodyText1:
                TextStyle(color: Color(int.parse(controller.secondaryColor))),
            bodyText2:
                TextStyle(color: Color(int.parse(controller.secondaryColor))),
            caption:
                TextStyle(color: Color(int.parse(controller.secondaryColor))),
            button:
                TextStyle(color: Color(int.parse(controller.secondaryColor))),
            overline:
                TextStyle(color: Color(int.parse(controller.secondaryColor))),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Color(int.parse(controller.primaryColor)),
            foregroundColor: Color(int.parse(controller.secondaryColor)),
          ),
          primaryColor: Color(int.parse(controller.primaryColor)),
          colorScheme: ColorScheme.light(
            primary: Color(int.parse(controller.primaryColor)),
            secondary: Color(int.parse(controller.secondaryColor)),
          )),
      home: const Login(),
    );
  }
}
