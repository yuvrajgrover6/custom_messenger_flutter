import 'package:bubble/bubble.dart';
import 'package:custom_messenger/auth/controller/auth_controller.dart';
import 'package:custom_messenger/chat/controller/chat_view_controller.dart';
import 'package:custom_messenger/home/views/homepage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../home/model/chat_message.dart';
import '../../home/views/all_chats_screen.dart';

class ChatView extends GetView<ChatViewController> {
  ChatView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    final authController = Get.find<AuthController>();
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        controller.focusNode.unfocus();
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Material(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: height * 0.03,
              color: primaryColor,
              child: Text(
                controller.chats.user.name.capitalizeFirst!,
                style: TextStyle(
                  fontSize: width * 0.05,
                ),
              ),
            ),
          ),
          titleSpacing: 0,
          leadingWidth: width * 0.19,
          leading: GestureDetector(
            onTap: () {
              controller.focusNode.unfocus();
              Get.offAll(() => const HomePage());
            },
            child: Container(
                margin: const EdgeInsets.symmetric(vertical: 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.arrow_back),
                    CircleAvatar(
                        backgroundImage:
                            NetworkImage(controller.chats.user.profilePicUrl)),
                  ],
                )),
          ),
          actions: [
            const Icon(Icons.search),
            SizedBox(width: width * 0.04),
            const Icon(Icons.call),
            PopupMenuButton(itemBuilder: (context) {
              return [const PopupMenuItem(child: Text('Block'))];
            })
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: controller.obx((state) => Container(
                      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                      child: ListView.builder(
                        controller: controller.controller,
                        itemCount: state?.length ?? 0,
                        itemBuilder: ((context, index) {
                          if (state?.isEmpty ?? true) {
                            const Center(
                                child: Text(
                              "Chat is empty",
                              style: TextStyle(fontSize: 24),
                            ));
                          }
                          final msg = state!.elementAt(index);
                          final isMe = msg.sender ==
                              authController.myUser.value!.mobileNumber;
                          return Container(
                            margin:
                                EdgeInsets.symmetric(vertical: height * 0.007),
                            child: Bubble(
                              color: isMe
                                  ? primaryColor.withOpacity(0.2)
                                  : Colors.white,
                              padding: BubbleEdges.only(left: width * 0.04),
                              alignment:
                                  isMe ? Alignment.topRight : Alignment.topLeft,
                              nip:
                                  isMe ? BubbleNip.rightTop : BubbleNip.leftTop,
                              child: Container(
                                constraints: BoxConstraints(
                                    minWidth: 0, maxWidth: width * 0.6),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(
                                        minWidth: 0,
                                        maxWidth: width * 0.48,
                                      ),
                                      child: Text(msg.msg,
                                          style: TextStyle(
                                              fontSize: width * 0.045,
                                              color: Colors.black87)),
                                    ),
                                    Container(
                                      constraints: BoxConstraints(
                                          minWidth: 0, maxWidth: width * 0.48),
                                      alignment: Alignment.bottomRight,
                                      width: width * 0.12,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            '  ${controller.getTime(msg.time)}',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: width * 0.025),
                                            textAlign: TextAlign.right,
                                          ),
                                          !isMe
                                              ? const SizedBox.shrink()
                                              : (msg.status == Status.unread)
                                                  ? Icon(Icons.check,
                                                      size: width * 0.04)
                                                  : Icon(
                                                      Icons.check_circle,
                                                      size: width * 0.04,
                                                      color: primaryColor,
                                                    ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ))),
            Row(
              children: [
                SizedBox(
                  width: width * 0.85,
                  child: Container(
                    margin: EdgeInsets.only(
                        left: width * 0.02, bottom: height * 0.01),
                    child: TextFormField(
                      controller: controller.msgController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  const BorderSide(color: Colors.transparent)),
                          fillColor: Colors.white,
                          filled: true),
                    ),
                  ),
                ),
                SizedBox(width: width * 0.01),
                CircleAvatar(
                  child: IconButton(
                      onPressed: () {
                        controller.sendMsg(controller.chats.user);
                      },
                      icon: Icon(Icons.send)),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
