



import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../authentification/controllers/signup_controller.dart';

class ForgetPasswordMailScreen extends StatefulWidget {
   ForgetPasswordMailScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordMailScreen> createState() => _ForgetPasswordMailScreenState();
}

class _ForgetPasswordMailScreenState extends State<ForgetPasswordMailScreen> {
  final controller = Get.put(SignUpController());
  final _formKey = GlobalKey<FormState>();
  

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;


    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 25 * 2,),
              Image(
                image: AssetImage("assets/Rp.png"),
                height: size.height * 0.3,
              ),
              Text(
                "Forget Password",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(height: 10),
              Text(
                "Enter your registered E-mail, to receive an email and reset your password click the button reset password",
                style: TextStyle(fontSize: 14), textAlign: TextAlign.center,
              ),
              SizedBox(height: 25 - 10),
              Form(
                key: _formKey,
                child: TextFormField(
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
              ),
              SizedBox(height: 25 - 10,),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      minimumSize: Size.fromHeight(50)
                  ),
                  label: Text("Reset Password", style: TextStyle(fontSize: 20)),
                  icon: Icon(CupertinoIcons.share_up, size: 25, color: Colors.lightBlue),
                  onPressed: (){
                    if (_formKey.currentState!.validate()) {
                      SignUpController.instance.resetPassword(controller.email.text.trim());
                    }
                  }
              ),
            ],
          ),
        ),
      ),
    );
  }
}

