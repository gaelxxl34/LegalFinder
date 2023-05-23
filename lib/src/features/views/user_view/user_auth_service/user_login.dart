import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:legalfinder/src/features/views/user_view/user_auth_service/user_signup.dart';

import '../../../../common_widgets/paassword_field.dart';
import '../../../../common_widgets/reset_password.dart';
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
                        const SizedBox(height: 24),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email address';
                            }
                            if (!RegExp(
                                r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                                .hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null; // Return null if the email is valid
                          },
                          controller: controller.email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            suffixIcon:   Icon(CupertinoIcons.mail)
                          ),
                        ),
                        const SizedBox(height: 16),
                        PasswordTextField(),
                        const SizedBox(height: 34),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              ForgetPasswordScreen.buildShowModalBottomSheet(context);
                            },
                            child: Text("Forget Password", style: TextStyle(color: Colors.blue),),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(),
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.black,
                              side: BorderSide(color: Colors.black),
                              padding: EdgeInsets.symmetric(vertical: 15),
                            ),
                            onPressed: (){
                              if (_formKey.currentState!.validate()) {
                                SignUpController.instance.log(controller.email.text.trim(), controller.password.text.trim());
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Processing Data')),
                              );

                            },
                            child: Text(
                              "Login".toUpperCase(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextButton(
                          onPressed: () => Get.to(UserSignUpScreen()),
                          child: Text.rich(
                            TextSpan(
                              text: "Don't have an Account ",
                              style:
                              TextStyle(fontSize: 16, color: Colors.black),
                              children: [
                                TextSpan(
                                  text: "Sign Up".toUpperCase(),
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
