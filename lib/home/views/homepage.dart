import 'package:custom_messenger/auth/controller/auth_controller.dart';
import 'package:custom_messenger/call/controller/theme_controller.dart';
import 'package:custom_messenger/call/view/settings.dart';
import 'package:custom_messenger/contact/controller/contact_controller.dart';
import 'package:custom_messenger/home/views/all_chats_screen.dart';
import 'package:custom_messenger/status/views/all_status.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../call/view/all_calls.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());
    Get.find<ContactController>();
    final controller1 = Get.find<ThemeController>();
    return DefaultTabController(
      initialIndex: 0,
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(int.parse(controller1.primaryColor)),
          bottom: const TabBar(tabs: [
            Tab(text: 'CHATS'),
            // Tab(text: 'STATUS'),
            // Tab(text: 'CALLS')
          ]),
          title: const Text('Messenger'),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
            PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                      child: TextButton(
                    child: const Text('Settings'),
                    onPressed: () {
                      Get.to(() => SettingsScreen());
                    },
                  )),
                  PopupMenuItem(
                      child: TextButton(
                    child: const Text('Sign Out'),
                    onPressed: () {
                      controller.signOut();
                    },
                  ))
                ];
              },
            )
          ],
        ),
        body: TabBarView(children: [AllChatsScreen()]),
      ),
    );
  }
}
