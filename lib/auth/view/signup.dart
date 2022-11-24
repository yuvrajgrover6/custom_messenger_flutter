import 'package:custom_messenger/auth/controller/signUp_controller.dart';
import 'package:custom_messenger/auth/view/login.dart';
import 'package:custom_messenger/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'components/custom_text_field.dart';

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SignUpController());
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: GetBuilder<SignUpController>(builder: (controller) {
          return SingleChildScrollView(
            child: Container(
              alignment: Alignment.topLeft,
              width: width,
              height: height * 0.96,
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.45,
                    child: SvgPicture.asset(
                      'assets/svg/signup.svg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.5,
                    child: Form(
                      key: controller.nextKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Join Us',
                                style: TextStyle(
                                    fontSize: width * 0.06,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              ),
                              Text(
                                'Start Chatting With Friends',
                                style: TextStyle(
                                    fontSize: width * 0.04,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          CustomTextField(
                            width: width,
                            hint: 'Email',
                            controller: controller.emailController,
                            validator: validateEmail,
                          ),
                          CustomTextField(
                              width: width,
                              hint: 'Password',
                              validator: validatePassword,
                              controller: controller.passwordController),
                          SizedBox(
                            width: width,
                            height: height * 0.06,
                            child: ElevatedButton(
                                onPressed: () {
                                  controller.next();
                                },
                                child: controller.nextLoading
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                            color: Colors.white))
                                    : const Text('Next')),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Don\'t have an account?',
                                style: TextStyle(color: Colors.black),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.off(() => const Login());
                                },
                                child: const Text('Sign In'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
