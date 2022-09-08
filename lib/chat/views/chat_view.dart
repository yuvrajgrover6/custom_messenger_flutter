import 'package:flutter/material.dart';

class ChatView extends StatelessWidget {
  ChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('Yuvraj Grover'),
        leading: Container(
            margin: const EdgeInsets.symmetric(vertical: 7),
            child: CircleAvatar()),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: Icon(Icons.call)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              flex: 8, child: Container(color: Colors.yellow, width: width)),
          Expanded(child: Container(color: Colors.red, width: width)),
        ],
      ),
    );
  }
}
