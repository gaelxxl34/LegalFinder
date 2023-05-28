import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../repository/authentication_repo/auth_repo.dart';
import '../../../repository/user_repo/user_repository.dart';
import '../../views/admin_view/admin_dashboard.dart';
import '../../views/user_view/user_home/user_homescreen.dart';
import '../../views/welcome_screen.dart';
import '../models/user_model.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  // textfield to get the data from the sign up textfield
  late final email = TextEditingController();
  final password = TextEditingController();
  final fullName = TextEditingController();
  final role = TextEditingController();

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
      Get.snackbar("Password Reset",
          "Email Sent click on Spam in your email to access the email",
          colorText: Colors.green);
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", "${e.message}", colorText: Colors.red);
    }
  }


  Future<void> loginWithEmailPassword(String email, String password) async {
    print("Logging in with email: $email, password: $password");
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("Login successful");
      await checkUserRole();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar(
            "Error", "No user found with this email", colorText: Colors.red);
        print("User not found with email: $email");
      } else if (e.code == 'wrong-password') {
        Get.snackbar("Error", "Incorrect password", colorText: Colors.red);
        print("Incorrect password for email: $email");
      }
    }
  }

// check users role

  Future<void> checkUserRole() async {
    // Get the user's role from Firestore.
    User? user = FirebaseAuth.instance.currentUser;
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('Email', isEqualTo: user!.email)
        .get();
    DocumentSnapshot userSnapshot = snapshot.docs[0];
    String userRole = userSnapshot['Role'];

    // Switch on the role and navigate to the corresponding screen.
    switch (userRole) {
      case 'user':
        Get.to(UserHomePage());
        break;
      case 'admin':
        Get.to(AdminDashboard());
        break;
      case 'lawyer':
      // Get.to(LawyerController());
        break;
      case 'police':
      // Get.to(PoliceController());
        break;
      case 'judiciary':
      // Get.to(JudiciaryController());
        break;
      default:
        print(
            "there is an error we go to welcome screnn //////////////////////////99999999999999");
        Get.to(WelcomePage());
        break;
    }
  }

}