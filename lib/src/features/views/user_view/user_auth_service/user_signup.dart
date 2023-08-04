import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:legalfinder/src/constants/text.dart';
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
                                return nameError1;
                              }
                              if (value.length < 6) {
                                return nameError2;
                              }
                              return null; // Return null if the email is valid
                            },
                            controller: controller.fullName,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: fullN,
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

                            keyboardType: TextInputType.emailAddress,
                            maxLines: null,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return emailError1;
                              }
                              if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(value)) {
                                return emailError2;
                              }
                              return null; // Return null if the email is valid
                            },
                            controller: controller.email,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
                              hintText: email,
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
                                signUp.toUpperCase(),
                              ),
                            )),
                        const SizedBox(
                          height: 24,
                        ),
                        TextButton(
                          onPressed: () => Get.to(UserLoginScreen()),
                          child: Text.rich(TextSpan(
                            text: haveAlready,
                            style: TextStyle(fontSize: 15, color: Colors.black),
                            children: [
                              TextSpan(
                                text: login.toUpperCase(),
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