import 'package:care_connect/controller/implementation/loader_controller.dart';
import 'package:care_connect/controller/implementation/member_mangement_caretaker_phone.dart';
import 'package:care_connect/controller/services/authentication_service.dart';
import 'package:care_connect/view/add_member_screen.dart';
import 'package:care_connect/view/beneficiary_home_screen.dart';
import 'package:care_connect/view/member_details_screen.dart';
import 'package:care_connect/view/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:get/get.dart';

import '../controller/implementation/text_field_controller.dart';

class LoginScreen extends StatelessWidget {
  final bool isCaretaker;
  LoginScreen({super.key, required this.isCaretaker});
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LoaderController loader = Get.find();
  final MemberManagementOnCareTaker managementOnCareTaker = Get.find();
  final inputDecoration = InputDecoration(
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
      filled: true,
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none));

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final String text = isCaretaker ? "Caretaker" : "Beneficiary";
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        Get.to(() => const WelcomeScreen());
      },
      child: Scaffold(
        backgroundColor: Colors.green,
        body: SingleChildScrollView(
          child: Obx(
            () => Stack(
              children: [
                SafeArea(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '$text Login',
                          style: TextStyle(
                              fontSize: 20.dp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 7.h,
                        ),
                        Text(
                          'USERNAME',
                          style: TextStyle(
                              fontSize: 15.dp, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 2.h),
                          child: TextFormField(
                            decoration: inputDecoration,
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return "Email Is Empty";
                              } else if (!isEmailValid(val)) {
                                return "Email format Incorrect";
                              }
                              return null;
                            },
                            controller: emailController,
                          ),
                        ),
                        Text(
                          'PASSWORD',
                          style: TextStyle(
                              fontSize: 15.dp, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 2.h),
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.length < 6) {
                                return "password mustbe greater than 6 characters";
                              }
                              return null;
                            },
                            decoration: inputDecoration,
                            controller: passwordController,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // if (formKey.currentState!.validate()) {
                                AuthentincationServices()
                                    .resetPassword(email: emailController.text);
                                // }
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                    fontSize: 15.dp,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            SizedBox(
                              width: 10.w,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: const CircleBorder(),
                              backgroundColor: Colors.lightGreen.shade300,
                              minimumSize: Size(
                                20.w,
                                20.w,
                              ),
                            ),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                loader.start();
                                await AuthentincationServices()
                                    .loginuser(emailController.text,
                                        passwordController.text, isCaretaker)
                                    .then((value) {
                                  if (value) {
                                    managementOnCareTaker.getAndNavigate();
                                    if (isCaretaker) {
                                      Get.to(() => AddMemberScreen());
                                    } else {
                                      Get.to(() => BeneficiaryHomeScreen());
                                    }
                                    loader.stop();
                                  }
                                });
                              }
                            },
                            child: const Icon(
                              Icons.login,
                              color: Colors.green,
                            )),
                        SizedBox(
                          height: 2.h,
                        ),
                        if (isCaretaker)
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightGreen.shade300,
                                minimumSize: Size(
                                  20.w,
                                  6.h,
                                ),
                              ),
                              onPressed: () async {
                                final TextFieldController textFieldController =
                                    Get.find();
                                textFieldController.clear();
                                Get.to(() => MemberDetailsScreen(
                                    memberDetailsScreenState:
                                        MemberDetailsScreenState.register));
                              },
                              child: const Text(
                                'Register \n if you are new',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700),
                              )),
                      ],
                    ),
                  ),
                ),
                if (loader.loader.value) ...{
                  SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                        child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const CircularProgressIndicator(
                                  color: Colors.black,
                                ),
                                Text(
                                  'Loading',
                                  style: TextStyle(
                                      fontSize: 20.dp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                      ))
                }
              ],
            ),
          ),
        ),
      ),
    );
  }
}
