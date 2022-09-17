import 'package:custom_messenger/chat/views/chat_view.dart';
import 'package:custom_messenger/contact/views/contact_view.dart';
import 'package:custom_messenger/home/controller/all_chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllChats extends GetView<AllChatController> {
  const AllChats({Key? key}) : super(key: key);

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
              return const ListTile(
                // onTap: () => Get.to(() =>  ChatView()),
                leading: CircleAvatar(
                  radius: 30,
                ),
                title: Text('Yuvraj Grover'),
                subtitle: Text(
                  'Last message sent by Yuvraj Grover Last message sent by Yuvraj Grover',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text('9/3/22'),
              );
            },
          ),
        ),
      ),
    );
  }
}
