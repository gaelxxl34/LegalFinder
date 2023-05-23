import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:legalfinder/src/repository/authentication_repo/auth_repo.dart';


class MailVerficationController extends GetxController{
  late Timer _timer;


  @override
  void onInit() {
    super.onInit();
    sendVerificationEmail();
    setTimerForAutoRedict();
  }
  // send or resend email verification
  Future<void> sendVerificationEmail() async {
    try{
      await AuthentificationRepository.instance.sendVerificationEMail();
    } catch (e){
        print("Error occured");
    }
  }

  void setTimerForAutoRedict(){
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if(user!.emailVerified){
        timer.cancel();
        AuthentificationRepository.instance.setIniationScreen(user);
      }
    });
  }

  void manuallyCheckEmailVerification(){
    FirebaseAuth.instance.currentUser?.reload();
    final user = FirebaseAuth.instance.currentUser;
    if(user!.emailVerified){
      AuthentificationRepository.instance.setIniationScreen(user);
    }
  }

}
