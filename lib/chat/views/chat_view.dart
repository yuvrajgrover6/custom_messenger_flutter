import 'dart:io';

import 'package:custom_messenger/auth/models/user_model.dart';
import 'package:custom_messenger/chat/controller/chat_view_controller.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatView extends StatelessWidget {
  final UserModel user;
  const ChatView({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(ChatViewController());
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        title: Material(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            height: height * 0.03,
            color: Colors.blue,
            child: Text(
              user.name,
              style: TextStyle(fontSize: width * 0.05, color: Colors.white),
            ),
          ),
        ),
        titleSpacing: 0,
        leadingWidth: width * 0.19,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
              margin: const EdgeInsets.symmetric(vertical: 7),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.arrow_back),
                  CircleAvatar(
                      backgroundImage: NetworkImage(user.profilePicUrl)),
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
      body: GetBuilder<ChatViewController>(builder: (controller) {
        return FutureBuilder(
            future: controller.getMessages(user),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              final msgs = snapshot.data;
              print(msgs[0].msg);
              return Column(
                children: [
                  Expanded(
                    flex: 7,
                    child: Container(child: Container(width: width)),
                  ),
                  SizedBox(
                      height: height * 0.1,
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: width * 0.01,
                                vertical: height * 0.015),
                            width: width * 0.87,
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
                                      height: height,
                                      width: width * 0.1,
                                      child: GestureDetector(
                                        onTap: () =>
                                            controller.pickImage(context),
                                        child: const Icon(
                                          Icons.attach_file,
                                          color: Colors.grey,
                                        ),
                                      )),
                                  Container(
                                    alignment: Alignment.center,
                                    padding:
                                        EdgeInsets.only(bottom: height * 0.008),
                                    width: width * 0.6,
                                    child: TextFormField(
                                        focusNode: controller.focusNode,
                                        controller: controller.msgController,
                                        style:
                                            TextStyle(fontSize: height * 0.022),
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                        )),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      controller.isEmojiVisible.value =
                                          !controller.isEmojiVisible.value;
                                      controller.focusNode.unfocus();

                                      controller.focusNode.canRequestFocus =
                                          true;
                                    },
                                    child: Container(
                                        alignment: Alignment.center,
                                        height: height,
                                        width: width * 0.1,
                                        child: const Icon(
                                          Icons.emoji_emotions,
                                          color: Colors.grey,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: width * 0.01),
                          CircleAvatar(
                              child: IconButton(
                                  onPressed: () {
                                    controller.sendMsg(user);
                                  },
                                  icon: Icon(Icons.send)))
                        ],
                      )),
                  Obx(
                    () => Offstage(
                      offstage: !controller.isEmojiVisible.value,
                      child: SizedBox(
                        height: 250,
                        child: EmojiPicker(
                            textEditingController: controller.msgController,
                            onEmojiSelected: (Category category, Emoji emoji) {
                              controller.msgController.text =
                                  controller.msgController.text + emoji.emoji;
                            },
                            onBackspacePressed: () {
                              (controller.msgController.text.length - 1);
                            },
                            config: Config(
                                columns: 7,
                                emojiSizeMax:
                                    32 * (Platform.isIOS ? 1.30 : 1.0),
                                verticalSpacing: 0,
                                horizontalSpacing: 0,
                                gridPadding: EdgeInsets.zero,
                                initCategory: Category.RECENT,
                                bgColor: const Color(0xFFF2F2F2),
                                indicatorColor: Colors.blue,
                                iconColor: Colors.grey,
                                iconColorSelected: Colors.blue,
                                progressIndicatorColor: Colors.blue,
                                backspaceColor: Colors.blue,
                                skinToneDialogBgColor: Colors.white,
                                skinToneIndicatorColor: Colors.grey,
                                enableSkinTones: true,
                                showRecentsTab: true,
                                recentsLimit: 28,
                                replaceEmojiOnLimitExceed: false,
                                noRecents: const Text(
                                  'No Recents',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.black26),
                                  textAlign: TextAlign.center,
                                ),
                                tabIndicatorAnimDuration: kTabScrollDuration,
                                categoryIcons: const CategoryIcons(),
                                buttonMode: ButtonMode.MATERIAL)),
                      ),
                    ),
                  ),
                ],
              );
            });
      }),
    );
  }
}
