import 'package:custom_messenger/contact/controller/contact_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class ContactView extends StatelessWidget {
  const ContactView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).primaryColor;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    Get.put(ContactController());
    return GetBuilder<ContactController>(builder: (controller) {
      return Scaffold(
          appBar: AppBar(
            title: const Text('Select Contact'),
            actions: [
              IconButton(
                  onPressed: () async {
                    await controller.checkforNonChatedNumbers();
                    controller.update();
                  },
                  icon: const Icon(Icons.refresh))
            ],
          ),
          body: Container(
            padding: EdgeInsets.symmetric(
              vertical: height * 0.01,
            ),
            height: height,
            width: width,
            child: controller.isLoading
                ? Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Wrap(children: [
                        Text(
                          'Please have patience, we are fetching your contacts',
                          style: TextStyle(fontSize: 20, color: color),
                          textAlign: TextAlign.center,
                        )
                      ]),
                      SizedBox(height: height * 0.1),
                      LottieBuilder.asset('assets/lottie/loading.json'),
                    ],
                  ))
                : Obx(() => ListView.builder(
                      itemCount: controller.nonMatchedContacts!.value.length,
                      itemBuilder: (BuildContext context, int index) {
                        final user =
                            controller.nonMatchedContacts!.value[index];
                        return ListTile(
                          onTap: () => controller.onPress(user),
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(user.profilePicUrl),
                            radius: width * 0.1,
                          ),
                          title: Text(user.name,
                              style: TextStyle(color: Colors.black)),
                          subtitle: Text(
                            user.mobileNumber,
                            style: TextStyle(color: Colors.grey),
                          ),
                          trailing: IconButton(
                              icon: const Icon(Icons.message),
                              onPressed: () {}),
                        );
                      },
                    )),
          ));
    });
  }
}
