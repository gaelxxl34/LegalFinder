import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../repository/authentication_repo/auth_repo.dart';
import '../../../repository/user_repo/user_repository.dart';
import '../models/user_model.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  // textfield to get the data from the sign up textfield
  late final email = TextEditingController();
  final password = TextEditingController();
  final fullName = TextEditingController();

  final UserRepo = Get.put(UserRepository());

  void log(String email, String password) {
    AuthentificationRepository.instance.login(email, password);
  }

  void registerUser(String email, String password, UserModel user) {
    AuthentificationRepository.instance
        .createUserWithEmailAndPassword(email, password, user);
  }

  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Get.snackbar("Password Reset", "Email Sent click on Spam in your email to access the email", colorText: Colors.green);
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", "${e.message}", colorText: Colors.red);
    }
  }
}
