import 'package:custom_messenger/chat/views/chat_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllChats extends StatelessWidget {
  const AllChats({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.message),
      ),
      body: SizedBox(
          height: height,
          width: width,
          child: ListView.builder(
              itemCount: 10,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  onTap: () => Get.to(() => ChatView()),
                  leading: const CircleAvatar(
                    radius: 30,
                  ),
                  title: const Text('Yuvraj Grover'),
                  subtitle: const Text(
                    'Last message sent by Yuvraj Grover Last message sent by Yuvraj Grover',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Text('9/3/22'),
                );
              })),
    );
  }
}
