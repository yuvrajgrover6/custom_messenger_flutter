import 'package:custom_messenger/auth/controller/login_controller.dart';
import 'package:custom_messenger/auth/view/signup.dart';
import 'package:custom_messenger/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'components/custom_text_field.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(LoginController());
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: GetBuilder<LoginController>(builder: (controller) {
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
                      'assets/svg/login.svg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome Back',
                              style: TextStyle(
                                fontSize: width * 0.06,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Login to continue',
                              style: TextStyle(
                                fontSize: width * 0.04,
                                fontWeight: FontWeight.w500,
                              ),
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
                                controller.signIn();
                              },
                              child: controller.isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                          color: Colors.white))
                                  : const Text('Login')),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Don\'t have an account?'),
                            TextButton(
                              onPressed: () {
                                Get.off(() => const SignUp());
                              },
                              child: const Text('Sign Up'),
                            ),
                          ],
                        ),
                      ],
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
