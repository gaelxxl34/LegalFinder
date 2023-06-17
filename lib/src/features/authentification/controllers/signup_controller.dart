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
import '../../views/admin_view/add_data/view_legaladvices.dart';
import '../../views/admin_view/admin_dashboard.dart';
import '../../views/admin_view/admin_navbar.dart';
import '../../views/judiciary_view/judiciary_home/judiciary_homescreen.dart';
import '../../views/judiciary_view/judiciary_service/view_uploade_judgement.dart';
import '../../views/lawyers_view/lawyer_home/lawyer_homescreen.dart';
import '../../views/police_view/police_home/police_homscreen.dart';
import '../../views/police_view/police_services/view_uploaded_infos.dart';
import '../../views/user_view/user_home/user_homescreen.dart';
import '../../views/welcome_screen.dart';
import '../models/other_models.dart';
import '../models/user_model.dart';

class SignUpController extends GetxController {
  static SignUpController get instance => Get.find();

  // textfield to get the data from the sign up textfield
  late final email = TextEditingController();
  final password = TextEditingController();
  final fullName = TextEditingController();
  final role = TextEditingController();
  final field = TextEditingController();
  final name = TextEditingController();
  final suspect = TextEditingController();
  final description = TextEditingController();
  final phone = TextEditingController();
  final details = TextEditingController();
  final title = TextEditingController();


  final UserRepo = Get.put(UserRepository());



  void registerUser(String email, String password, UserModel user) {
    AuthentificationRepository.instance
        .createUserWithEmailAndPassword(email, password, user);
  }
  void registerOthers(String email, String password,  OthersModel user) {
    AuthentificationRepository.instance
        .createUserWithEmailAndPassword_For_Others(email, password, user);
  }
  void AddLawyer(String email, String password, Admin_Lawyer_Model uSer){
    AuthentificationRepository.instance
        .createUserWithEmailAndPassword_For_Lawyer(email, password, uSer);
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
        password: password
      );

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
        Get.to(() => UserHomePage());
        break;
      case 'admin':
        Get.to(() => AdminNavbar());
        break;
      case 'lawyer':
        Get.to(() => LawyerHomePage());
        break;
      case 'police':
        Get.to(() => PoliceHomePage());
        break;
      case 'judiciary':
        Get.to(() => JudiciaryHomePage());
        break;
      default:
        await FirebaseAuth.instance.signOut();
        Get.snackbar("Error", "You don't have access to this app", colorText: Colors.red);
        Get.to(() => WelcomePage());
        break;
    }
    Get.snackbar("Logging", "Successfully", colorText: Colors.green);
  }


  // -- This method is used by the police role to add wanted criminals
// -- To our catalogue and also display others important information

Future<void> addWantedCriminals(Wanted_Criminals_Model user) async {
  await UserRepo.createForPolice(user);
  Get.to(() => PoliceUploadedInfo());
}

Future<void> addDocument(Document_Model user) async{
 await UserRepo.createDocument(user);
  Get.to(()=> ViewUploadedJudgement());
}

  Future<void> addData(LegalCase_Model user) async{
    await UserRepo.createData(user);
  }

  Future<void> addTips(Security_Tips_Model user) async{
    await UserRepo.createTips(user);
  }

  Future<void> addQuote(Quote_Model user) async{
    await UserRepo.createQuote(user);
  }

}