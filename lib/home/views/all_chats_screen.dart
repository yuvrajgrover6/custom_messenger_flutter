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
      body: GetBuilder<AllChatController>(builder: (controller) {
        return SizedBox(
          height: height,
          width: width,
          child: ListView.builder(
            itemCount: controller.chats?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              if (controller.chats == null) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListTile(
                onTap: () => Get.to(
                  () => ChatView(),
                  binding: BindingsBuilder.put(() {
                    return Get.put(
                        ChatViewController(controller.chats![index]));
                  }),
                ),
                leading: GestureDetector(
                  onTap: () {},
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                        controller.chats?[index].user.profilePicUrl ?? ''),
                  ),
                ),
                title: Text(controller.chats![index].user.name,
                    style: TextStyle(color: Colors.black)),
                subtitle: Text(
                  controller.chats![index].chat.lastSend,
                  style: const TextStyle(color: Colors.grey),
                ),
                trailing: Text(
                  controller.getMessageDate(
                      controller.chats![index].chat.lastSeenTime),
                  style:
                      TextStyle(color: Colors.black54, fontSize: width * 0.03),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
