import 'package:custom_messenger/call/view/all_calls.dart';
import 'package:custom_messenger/home/views/all_chats.dart';
import 'package:custom_messenger/status/views/all_status.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 2,
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
            IconButton(onPressed: () {}, icon: Icon(Icons.search)),
            PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return [const PopupMenuItem(child: Text('Hello'))];
              },
            )
          ],
        ),
        body: const TabBarView(children: [AllChats(), AllStatus(), AllCalls()]),
      ),
    );
  }
}
