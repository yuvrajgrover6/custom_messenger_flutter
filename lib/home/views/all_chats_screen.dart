import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_messenger/chat/views/chat_view.dart';
import 'package:custom_messenger/contact/views/contact_view.dart';
import 'package:custom_messenger/home/controller/all_chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../chat/controller/chat_view_controller.dart';

class AllChatsScreen extends StatelessWidget {
  const AllChatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AllChatController());
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const ContactView());
        },
        child: const Icon(Icons.message),
      ),
      body: SizedBox(
        height: height,
        width: width,
        child: Obx(
          () => ListView.builder(
            itemCount: controller.usersList?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              if (controller.usersList == null) {
                const Center(
                    child: Text(
                  "Chat is empty",
                  style: TextStyle(fontSize: 24),
                ));
              }
              return ListTile(
                onTap: () => Get.to(
                  () => ChatView(),
                  binding: BindingsBuilder.put(() {
                    return Get.put(ChatViewController(
                        controller.usersAndChatsList![index]));
                  }),
                ),
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                      controller.usersAndChatsList![index].user.profilePicUrl),
                ),
                title: Text(controller.usersAndChatsList![index].user.name),
                subtitle: Text(
                    controller.usersAndChatsList?[index].chat.lastSend ?? ""),
                trailing: Text(
                  controller.getMessageDate(
                      controller.usersAndChatsList?[index].chat.lastSeenTime ??
                          Timestamp.now()),
                  style:
                      TextStyle(color: Colors.black54, fontSize: width * 0.03),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
