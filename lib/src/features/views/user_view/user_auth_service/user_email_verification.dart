import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../authentification/controllers/mailverification_controller.dart';


class EmailVerification extends StatefulWidget {
  const EmailVerification({Key? key}) : super(key: key);

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  // bool isEmailVerified = false;
  // bool canResendEmail = false;
  //
  // Timer? timer;
  //
  // @override
  // void initState() {
  //   super.initState();
  //
  //   // -- First create the user before verifying
  //   isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
  //
  //   if (!isEmailVerified) {
  //     sendVerificationEMail();
  //
  //     timer = Timer.periodic(
  //       Duration(seconds: 2),
  //           (_) => checkEmailVerified(),
  //     );
  //   }
  // }
  //
  // @override
  // void dispose() {
  //   timer?.cancel();
  //
  //   super.dispose();
  // }
  //
  // Future checkEmailVerified() async {
  //   // reload after email is verified
  //   await FirebaseAuth.instance.currentUser!.reload();
  //
  //   setState(() {
  //     isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
  //   });
  //
  //   if (isEmailVerified == true) {
  //     Get.to(UserHomePage());
  //   }
  // }
  //
  // Future sendVerificationEMail() async {
  //   try {
  //     final user = FirebaseAuth.instance.currentUser!;
  //     await user.sendEmailVerification();
  //     setState(() => canResendEmail = false);
  //     await Future.delayed(Duration(seconds: 5));
  //     setState(() => canResendEmail = true);
  //   } catch (e) {
  //     Get.snackbar("Invalid Email", "Or not Recorded", colorText: Colors.red);
  //   }
  // }

  final controller = Get.put(MailVerficationController());
  final uSer = FirebaseAuth.instance.currentUser!;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        title: Text("Email Verfication"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(CupertinoIcons.mail_solid, size: 140,),
            SizedBox(height: 10,),
            Text("A verification email has been sent to ${uSer.email!}",
              style: TextStyle(fontSize: 20), textAlign: TextAlign.center,),
            SizedBox(height: 20,),
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    minimumSize: Size.fromHeight(50)
                ),
                label: Text("Continue", style: TextStyle(fontSize: 18)),
                icon: Icon(CupertinoIcons.check_mark_circled, size: 30, color: Colors.green,),
                onPressed: ()=> controller.manuallyCheckEmailVerification()
            ),
            SizedBox(height: 10),
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    minimumSize: Size.fromHeight(50)
                ),
                label: Text("Resend Email", style: TextStyle(fontSize: 20)),
                icon: Icon(CupertinoIcons.share_up, size: 25, color: Colors.lightBlue),
                onPressed: ()=> controller.sendVerificationEmail()
            ),
            SizedBox(height: 15,),
            ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white24,
                    minimumSize: Size.fromHeight(50)
                ),
                label: Text("Cancel", style: TextStyle(fontSize: 20)),
                icon: Icon(CupertinoIcons.nosign, size: 25, color: Colors.red,),
                onPressed: () => FirebaseAuth.instance.signOut()
            ),
          ],

        ),
      ),
    );
  }
}