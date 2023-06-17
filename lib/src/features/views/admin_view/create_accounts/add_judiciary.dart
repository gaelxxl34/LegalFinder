import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../common_widgets/paassword_field.dart';
import '../../../authentification/controllers/signup_controller.dart';
import '../../../authentification/models/user_model.dart';

class AddJudiciary extends StatefulWidget {
  const AddJudiciary({Key? key}) : super(key: key);

  @override
  State<AddJudiciary> createState() => _AddJudiciaryState();
}

class _AddJudiciaryState extends State<AddJudiciary> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.put(SignUpController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(250),
                        color: Color(0xFF08155E).withOpacity(0.1),
                      ),
                      child: SizedBox(

                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.cabin_outlined, size: 85, color: Colors.blue,),
                            Text("Judiciary")
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
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
                                contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
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
                              keyboardType: TextInputType.emailAddress,
                              maxLines: null,
                              textInputAction: TextInputAction.newline,

                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
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
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          PasswordTextField(),
                          const SizedBox(height: 10),
                          Container(
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter a role';
                                }
                                if (value.length < 3) {
                                  return 'The role must be at least 3 characters long';
                                }
                                return null; // Return null if the email is valid
                              },
                              controller: controller.role,
                              decoration: InputDecoration(
                                suffixIcon: Icon(Icons.work_outline, color: Colors.black,),
                                hintText: 'Role',
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
                                  return 'Please enter a phone number';
                                }
                                if (!value.startsWith('+256')) {
                                  return 'Please start the phone number with "+256" ';
                                }
                                return null;
                              },
                              controller: controller.phone,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
                                suffixIcon: Icon(FontAwesomeIcons.phone, color: Colors.black,),
                                hintText: '+256',
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
                          const SizedBox(height: 24),
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
                                    final user = OthersModel(
                                      fullname: controller.fullName.text.trim(),
                                      email: controller.email.text.trim(),
                                      role: controller.role.text.trim(),
                                      phone: controller.phone.text.trim(),
                                    );

                                    SignUpController.instance.registerOthers(controller.email.text.trim(), controller.password.text.trim(), user);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Processing Data'), backgroundColor: Colors.black,),
                                    );


                                  }


                                },

                                child: Text(
                                  "Create Account".toUpperCase(),
                                ),
                              )),


                        ],
                      ),
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