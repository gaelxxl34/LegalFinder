import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:legalfinder/src/features/views/police_view/police_auth_service/police_login.dart';
import 'package:legalfinder/src/features/views/user_view/user_auth_service/user_login.dart';

import 'judiciary_view/judiciary_auth_service/judiciary_login.dart';
import 'lawyers_view/lawyer_auth_service/lawyer_login.dart';


class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height;
    var width = mediaQuery.size.width;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage(
                      "assets/es.png"),
                  height: height * 0.5,
                  width: width * 0.75,
                ),
                Column(
                  children: [
                    Text(
                      "LegalFinder",
                      style:
                      TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "The app that helps you find justice at your fingertips",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(height: height * 0.2,),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.to(UserLoginScreen()),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(),
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red,
                          side: BorderSide(color: Colors.black),
                          padding: EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: Text(
                          "User Account",
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: ()=> Get.to(LawyerLogin()),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(),
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.black,
                          side: BorderSide(color: Colors.black),
                          padding: EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: Text(
                          "Lawyer Account",
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.0),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: ()=> Get.to(PoliceLogin()),
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(),
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                          side: BorderSide(color: Colors.black),
                          padding: EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: Text(
                          "Law Enforcers Account",
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: ()=> Get.to(JudiciaryLogin()),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(),
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                          side: BorderSide(color: Colors.black),
                          padding: EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: Text(
                          "Librarian Account",
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}