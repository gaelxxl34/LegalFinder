import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:legalfinder/src/features/views/user_view/user_auth_service/user_login.dart';

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
                      child: Icon(Icons.person, size: 65)
                  ),
                  const SizedBox(
                    height: 24,
                  ),
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
                            hintText: 'Email',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters long';
                            }
                            // Add any additional password validation logic here, such as requiring specific characters or patterns

                            return null; // Return null if the password is valid
                          },
                          controller: controller.password,
                          decoration: InputDecoration(
                            hintText: 'Password',
                          ),
                          obscureText: true,
                          // controller: _passwordController,
                        ),

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