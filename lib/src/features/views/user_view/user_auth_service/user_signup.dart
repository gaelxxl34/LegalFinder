import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:legalfinder/src/features/views/user_view/user_auth_service/user_login.dart';

import '../../../../common_widgets/paassword_field.dart';
import '../../../authentification/controllers/signup_controller.dart';
import '../../../authentification/models/user_model.dart';


class UserSignUpScreen extends StatefulWidget {
  const UserSignUpScreen({Key? key}) : super(key: key);

  @override
  _UserSignUpScreenState createState() => _UserSignUpScreenState();
}

class _UserSignUpScreenState extends State<UserSignUpScreen> {
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
                  SizedBox(
                      child: Icon(CupertinoIcons.person_alt_circle_fill, size: 70)
                  ),
                  const SizedBox(height: 24),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please your fullname';
                            }

                            return null; // Return null if the email is valid
                          },
                          controller: controller.fullName,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            suffixIcon: Icon(CupertinoIcons.textbox),
                            hintText: 'Fullname',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter an email address';
                            }
                            if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null; // Return null if the email is valid
                          },
                          controller: controller.email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            suffixIcon: Icon(CupertinoIcons.mail),
                            hintText: 'Email',
                          ),
                        ),
                        const SizedBox(height: 16),
                        PasswordTextField(),

                        const SizedBox(
                          height: 24,
                        ),
                        SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(),
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.black,
                                  side: BorderSide(color: Colors.black),
                                  padding: EdgeInsets.symmetric(vertical: 15)
                              ),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  final user = UserModel(
                                    fullname: controller.fullName.text.trim(),
                                    email: controller.email.text.trim(),
                                  );

                                  SignUpController.instance.registerUser(controller.email.text.trim(), controller.email.text.trim(), user);
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Processing Data')),
                                );

                              },
                              child: Text(
                                "Sign Up".toUpperCase(),
                              ),
                            )),
                        const SizedBox(
                          height: 24,
                        ),
                        TextButton(
                          onPressed: () => Get.to(UserLoginScreen()),
                          child: Text.rich(TextSpan(
                            text: "Already have an Account ",
                            style: TextStyle(fontSize: 15, color: Colors.black),
                            children: [
                              TextSpan(
                                text: "Login".toUpperCase(),
                                style: TextStyle(color: Colors.red),
                              )
                            ],
                          )),
                        )
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