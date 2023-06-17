import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../common_widgets/login_page.dart';
import '../../../../common_widgets/paassword_field.dart';
import '../../../../common_widgets/reset_password.dart';
import '../../../authentification/controllers/signup_controller.dart';
import 'lawyer_signup.dart';

class LawyerLogin extends StatefulWidget {
  const LawyerLogin({Key? key}) : super(key: key);

  @override
  State<LawyerLogin> createState() => _LawyerLoginState();
}

class _LawyerLoginState extends State<LawyerLogin> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.put(SignUpController());


  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height;
    var width = mediaQuery.size.width;

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
                        Container(
                          child: Image(image: AssetImage("assets/lawyer.png"), width: width * 1, height: height * 0.3,),
                        ),
                        LoginWidget(),
                        TextButton(
                          onPressed: () => Get.to(LawyerSignUp()),
                          child: Text.rich(
                            TextSpan(
                              text: "Request For an Account ",
                              style:
                              TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold),
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


