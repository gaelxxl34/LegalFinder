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
                        Container(
                          height: 45,
                          child: TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter your Fullname';
                              }
                              if (value.length < 6) {
                                return 'Your Fullname must be at least 8 characters long';
                              }
                              return null; // Return null if the email is valid
                            },
                            controller: controller.fullName,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'Full Name',
                              suffixIcon: Icon(CupertinoIcons.textbox, color: Colors.black),
                              hintStyle: TextStyle(color: Colors.black),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 1, color: Colors.black),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 1, color: Colors.blue),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          child: TextFormField(

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
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            textInputAction: TextInputAction.newline,                            decoration: InputDecoration(
                              hintText: 'Email',
                              suffixIcon: Icon(CupertinoIcons.mail, color: Colors.black),
                              hintStyle: TextStyle(color: Colors.black),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 1, color: Colors.black),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(width: 1, color: Colors.blue),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        PasswordTextField(),
                        const SizedBox(
                          height: 24,
                        ),
                        SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                                  user.generateRandomFCMToken();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Processing Data'), backgroundColor: Colors.black,),
                                  );
                                  SignUpController.instance.registerUser(controller.email.text.trim(), controller.password.text.trim(), user);
                                }
                               

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