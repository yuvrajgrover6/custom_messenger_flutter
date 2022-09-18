import 'dart:ui';

import 'package:custom_messenger/chat/controller/chat_view_controller.dart';
import 'package:custom_messenger/chat/views/chat_view.dart';
import 'package:custom_messenger/contact/views/contact_view.dart';
import 'package:custom_messenger/home/controller/all_chat_controller.dart';
import 'package:custom_messenger/home/model/chat.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AllChatsScreen extends GetView<AllChatController> {
  const AllChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(AllChatController());
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => ContactView());
        },
        child: const Icon(Icons.message),
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: controller.obx(
          (state) => ListView.builder(
            itemCount: state?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              if (state?.isEmpty ?? true) {
                Center(
                    child: Text(
                  "Chat is empty",
                  style: TextStyle(fontSize: 24),
                ));
              }
              final UserModelPlusChat userAndChat = state![index];
              return ListTile(
                onTap: () => Get.to(
                  () => ChatView(),
                  binding: BindingsBuilder.put(() {
                    return Get.put(ChatViewController(userAndChat));
                  }),
                ),
                leading: CircleAvatar(
                  radius: 30,
                ),
                title: Text(userAndChat.user.name),
                subtitle: Text(userAndChat.chat.lastSend),
                trailing: Text(DateFormat('dd/MM/yy')
                    .format(userAndChat.chat.lastSeenTime.toDate())),
              );
            },
          ),
        ),
      ),
    );
  }
}
