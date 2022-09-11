import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatView extends StatelessWidget {
  ChatView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Material(
          child: Container(
            height: height * 0.03,
            color: Colors.blue,
            child: Text(
              'Yuvraj Grover',
              style: TextStyle(fontSize: width * 0.05, color: Colors.white),
            ),
          ),
        ),
        leadingWidth: width * 0.19,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
              margin: const EdgeInsets.symmetric(vertical: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Icon(Icons.arrow_back),
                  CircleAvatar(),
                ],
              )),
        ),
        actions: [
          Icon(Icons.search),
          SizedBox(width: width * 0.04),
          Icon(Icons.call),
          PopupMenuButton(itemBuilder: (context) {
            return [PopupMenuItem(child: Text('Block'))];
          })
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                height: height * 0.785,
                child: Container(color: Colors.yellow, width: width)),
            Container(
                height: height * 0.1,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.03, vertical: height * 0.015),
                  color: Colors.yellow,
                  width: width,
                  child: Container(
                    height: height,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(bottom: height * 0.008),
                          width: width * 0.75,
                          child: TextFormField(
                              style: TextStyle(fontSize: height * 0.022),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              )),
                        ),
                        Container(
                            alignment: Alignment.center,
                            height: height,
                            width: width * 0.1,
                            child: const Icon(
                              Icons.emoji_emotions,
                              color: Colors.grey,
                            ))
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
