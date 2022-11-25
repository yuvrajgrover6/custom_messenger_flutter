import 'package:custom_messenger/auth/view/components/custom_text_field.dart';
import 'package:custom_messenger/settings/controller/my_profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../auth/controller/auth_controller.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MyProfileController());
    final user = Get.find<AuthController>().myUser.value;
    final secondaryColor = Theme.of(context).colorScheme.secondary;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: GetBuilder<MyProfileController>(builder: (controller) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: width * 0.025),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height * 0.02),
                GestureDetector(
                    onTap: () => controller.pickImage(context),
                    child: (controller.bytes != null)
                        ? Center(
                            child: CircleAvatar(
                            radius: width * 0.2,
                            backgroundImage: MemoryImage(controller.bytes!),
                          ))
                        : Center(
                            child: controller.pfpUrl == null
                                ? CircleAvatar(
                                    radius: width * 0.2,
                                    backgroundColor: primaryColor,
                                    child: Icon(
                                      Icons.person,
                                      size: width * 0.15,
                                      color: secondaryColor,
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: width * 0.2,
                                    backgroundImage:
                                        NetworkImage(controller.pfpUrl!),
                                  ),
                          )),
                SizedBox(height: height * 0.02),
                CustomTextField(
                  width: width,
                  hint: controller.name ?? 'Enter Your Name',
                  controller: controller.nameController,
                ),
                SizedBox(height: height * 0.02),
                CustomTextField(
                  width: width,
                  hint: 'Enter Your Email',
                  readOnly: true,
                  initialValue: user!.email,
                ),
                SizedBox(height: height * 0.02),
                CustomTextField(
                  width: width,
                  hint: 'Enter Your Phone Number',
                  readOnly: true,
                  initialValue: user.mobileNumber,
                ),
                SizedBox(height: height * 0.045),
                Center(
                  child: SizedBox(
                      width: width * 0.35,
                      height: 45,
                      child: ElevatedButton(
                          onPressed: () {
                            controller.updateProfile();
                          },
                          child: controller.loading
                              ? CircularProgressIndicator(color: secondaryColor)
                              : Text('Update Profile'))),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
