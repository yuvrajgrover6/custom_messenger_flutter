import 'package:custom_messenger/chat/views/chat_view.dart';
import 'package:custom_messenger/contact/controller/contact_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class ContactView extends StatelessWidget {
  const ContactView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    Get.put(ContactController());
    return GetBuilder<ContactController>(builder: (controller) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Select Contact'),
            actions: [
              IconButton(
                  onPressed: () {
                    controller.matchContact();
                  },
                  icon: const Icon(Icons.refresh))
            ],
          ),
          body: Container(
            padding: EdgeInsets.symmetric(
              // horizontal: width * 0.04,
              vertical: height * 0.01,
            ),
            height: height,
            width: width,
            child: controller.isLoading
                ? Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Wrap(children: const [
                        Text(
                          'Please have patience, we are fetching your contacts',
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        )
                      ]),
                      SizedBox(height: height * 0.1),
                      LottieBuilder.asset('assets/lottie/loading.json'),
                    ],
                  ))
                : ListView.builder(
                    itemCount: controller.matchedContacts?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      final user = controller.matchedContacts![index];
                      return ListTile(
                        // TODO: pass binding ChatRoomController
                        // onTap: () => Get.to(() => ChatView()),
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.profilePicUrl),
                          radius: width * 0.1,
                        ),
                        title: Text(user.name),
                        subtitle: Text(user.mobileNumber),
                        trailing: IconButton(
                            icon: const Icon(Icons.message), onPressed: () {}),
                      );
                    },
                  ),
          ));
    });
  }
}
