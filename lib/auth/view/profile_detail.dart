
import 'package:custom_messenger/auth/controller/signUp_controller.dart';
import 'package:custom_messenger/auth/view/components/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CreateProfile extends StatelessWidget {
  const CreateProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    Get.put(SignUpController());
    return Scaffold(
      body: GetBuilder<SignUpController>(builder: (controller) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: width * 0.05),
              width: width,
              child: Form(
                key: controller.signUpKey,
                child: Column(
                  children: [
                    SizedBox(height: height * 0.06),
                    GestureDetector(
                        onTap: () async {
                          controller.pickImage(context);
                        },
                        child: (controller.imageFiles.isEmpty)
                            ? CircleAvatar(radius: width * 0.25)
                            : CircleAvatar(
                                radius: width * 0.25,
                                backgroundImage: MemoryImage(controller.bytes!),
                              )),
                    SizedBox(height: height * 0.06),
                    CustomTextField(
                      width: width,
                      hint: 'Your Good Name',
                      controller: controller.nameController,
                    ),
                    SizedBox(height: height * 0.03),
                    CustomTextField(
                      width: width,
                      hint: 'Your Mobile Number',
                      controller: controller.mobileController,
                    ),
                    SizedBox(height: height * 0.05),
                    SizedBox(
                      width: width,
                      height: height * 0.06,
                      child: ElevatedButton(
                          onPressed: () {
                            controller.signUp();
                          },
                          child: controller.submitLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                      color: Colors.white))
                              : const Text('Sign Up')),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
