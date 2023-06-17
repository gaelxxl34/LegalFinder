import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:legalfinder/src/features/views/police_view/police_auth_service/police_signup.dart';

import '../../../../common_widgets/login_page.dart';
import '../../../../common_widgets/paassword_field.dart';
import '../../../../common_widgets/reset_password.dart';
import '../../../authentification/controllers/signup_controller.dart';


class PoliceLogin extends StatefulWidget {
  const PoliceLogin({Key? key}) : super(key: key);

  @override
  State<PoliceLogin> createState() => _PoliceLoginState();
}

class _PoliceLoginState extends State<PoliceLogin> {
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
                          child: Image(image: AssetImage("assets/police.png"), width: width * 1, height: height * 0.3,),
                        ),
                        LoginWidget(),
                        TextButton(
                          onPressed: () => Get.to(PoliceSignUp()),
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
