import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:legalfinder/src/features/views/user_view/user_auth_service/user_signup.dart';

import '../../../../common_widgets/login_page.dart';
import '../../../../common_widgets/paassword_field.dart';
import '../../../../common_widgets/reset_password.dart';
import '../../../../constants/text.dart';
import '../../../authentification/controllers/signup_controller.dart';

class UserLoginScreen extends StatefulWidget {
  const UserLoginScreen({Key? key}) : super(key: key);

  @override
  State<UserLoginScreen> createState() => _UserLoginScreenState();
}

class _UserLoginScreenState extends State<UserLoginScreen> {

  final _formKey = GlobalKey<FormState>();
  final controller = Get.put(SignUpController());



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(child: Icon(CupertinoIcons.person_alt_circle_fill, size: 70)),
                        LoginWidget(),
                        TextButton(
                          onPressed: () => Get.to(UserSignUpScreen()),
                          child: Text.rich(
                            TextSpan(
                              text: dontHave,
                              style:
                              TextStyle(fontSize: 14, color: Colors.black),
                              children: [
                                TextSpan(
                                  text: signUp.toUpperCase(),
                                  style: TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
