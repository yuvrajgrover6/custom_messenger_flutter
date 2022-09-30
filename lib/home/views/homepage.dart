import 'package:custom_messenger/auth/controller/auth_controller.dart';
import 'package:custom_messenger/call/view/all_calls.dart';
import 'package:custom_messenger/contact/controller/contact_controller.dart';
import 'package:custom_messenger/home/views/all_chats_screen.dart';
import 'package:custom_messenger/status/views/all_status.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());
    Get.find<ContactController>();
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(tabs: [
            Tab(text: 'CHATS'),
            Tab(text: 'STATUS'),
            Tab(text: 'CALLS')
          ]),
          title: const Text('Messenger'),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
            PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return [
                  PopupMenuItem(
                      child: TextButton(
                    child: const Text('Hello'),
                    onPressed: () {
                      controller.signOut();
                    },
                  ))
                ];
              },
            )
          ],
        ),
        body: const TabBarView(
            children: [AllChatsScreen(), AllStatus(), AllCalls()]),
      ),
    );
  }
}
