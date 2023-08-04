import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:legalfinder/src/features/authentification/controllers/signup_controller.dart';
import 'package:legalfinder/src/features/views/user_view/user_auth_service/user_login.dart';
import 'package:legalfinder/src/features/views/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/authentification/models/user_model.dart';
import '../../features/views/admin_view/admin_dashboard.dart';
import '../../features/views/admin_view/admin_navbar.dart';
import '../../features/views/judiciary_view/judiciary_home/judiciary_homescreen.dart';
import '../../features/views/lawyers_view/lawyer_home/lawyer_homescreen.dart';
import '../../features/views/police_view/police_home/police_homscreen.dart';
import '../../features/views/user_view/user_auth_service/user_email_verification.dart';
import '../../features/views/user_view/user_home/user_homescreen.dart';
import '../exception_handler/signup_email_password_failure.dart';
import '../user_repo/user_repository.dart';

class AuthentificationRepository extends GetxController {
  static AuthentificationRepository get instance => Get.find();

  // variables
  final auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;
  final UserRepo = Get.put(UserRepository());

  // var verificationId = ''.obs;

  @override
  void onReady() {
    Future.delayed(Duration(seconds: 5));
    firebaseUser = Rx<User?>(auth.currentUser);
    firebaseUser.bindStream(auth.userChanges());
    ever(firebaseUser, setIniationScreen);
    // setIniationScreen(firebaseUser.value);
  }

  Future<void> setIniationScreen(User? user) async {
    if (user != null) {
      // Check if the user has the admin role.
      QuerySnapshot adminSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('Email', isEqualTo: user.email)
          .where('Role', isEqualTo: 'admin')
          .get();

      if (adminSnapshot.docs.isNotEmpty) {
        // The current user has the admin role.
        // Navigate to the admin dashboard.
        Get.to(() => AdminNavbar());
        return;
      }

      // The current session is not for an admin user.
      // Check the user's role and navigate to the corresponding screen.
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('Email', isEqualTo: user.email)
          .get();
      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot userSnapshot = snapshot.docs[0];
        String userRole = userSnapshot['Role'];

        switch (userRole) {
          case 'user':
            user == null ? Get.offAll(() => const WelcomePage()) : user.emailVerified ? Get.offAll(() => UserHomePage()): Get.offAll(() => EmailVerification());
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
            print("There is an error, go to welcome screen");
            Get.to(() => WelcomePage());
            break;
        }
      } else {
        print("User is null");
        Get.to(() => WelcomePage());
        // Handle the case when the user is null
      }
    } else {
      print("User is null");
      Get.to(() => WelcomePage());
      // Handle the case when the user is null
    }
  }







  Future<void> createUserWithEmailAndPassword(
      String email, String password, UserModel user) async {
    try {
      CircularProgressIndicator();
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      firebaseUser.value != null
          ? Get.offAll(() => EmailVerification())
          : Get.offAll(() => const WelcomePage());
      await UserRepo.createUser(user);
    } on FirebaseAuthException catch (e) {
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      print('FIREBASE AUTH EXCEPTION -${ex.message}');
      throw ex;
    } catch (_) {
      final ex = SignUpWithEmailAndPasswordFailure();
      print('EXCEPTION -${ex.message}');
      throw ex;
    }
  }

  Future<void> createUserWithEmailAndPassword_For_Lawyer(
      String email, String password, Admin_Lawyer_Model user) async {
    try {
      // Create a secondary Firebase app
      FirebaseApp app = await Firebase.initializeApp(
          name: 'Secondary', options: Firebase.app().options);

      // Use the secondary app to create the user
      UserCredential userCredential = await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(email: email, password: password);

      // Create the user in your UserRepo
      await UserRepo.createLawyer(user);

      // Redirect the user back to the admin dashboard
      Get.to(() => AdminNavbar());

      // Delete the secondary app
      await app.delete();
    }on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Get.snackbar("Error", "Email already in use",
            colorText: Colors.red, backgroundColor: Colors.black);
      } else {
        final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
        print('FIREBASE AUTH EXCEPTION -${ex.message}');
        throw ex;
      }
    } catch (_) {
      final ex = SignUpWithEmailAndPasswordFailure();
      print('EXCEPTION -${ex.message}');
      throw ex;
    }
  }

  Future<void> createUserWithEmailAndPassword_For_Others(
      String email, String password, OthersModel user) async {
    try {
      // Create a secondary Firebase app
      FirebaseApp app = await Firebase.initializeApp(
          name: 'Secondary', options: Firebase.app().options);

      // Use the secondary app to create the user
      UserCredential userCredential = await FirebaseAuth.instanceFor(app: app)
          .createUserWithEmailAndPassword(email: email, password: password);

      await UserRepo.createOthers(user);

      // Redirect the user back to the admin dashboard
      Get.to(() => AdminNavbar());

      // Delete the secondary app
      await app.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Get.snackbar("Error", "Email already in use",
            colorText: Colors.red);
      } else {
        final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
        print('FIREBASE AUTH EXCEPTION -${ex.message}');
        throw ex;
      }
    } catch (_) {
      final ex = SignUpWithEmailAndPasswordFailure();
      print('EXCEPTION -${ex.message}');
      throw ex;
    }
  }



  // Email Verification

  Future<void> sendVerificationEMail() async {
    try {
      auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      Get.snackbar("click on cancel", "and try again", colorText: Colors.red);
    } catch (e) {
      Get.snackbar("Try resend", " email", colorText: Colors.red);
    }
  }

// log out function
  Future<void> logout() async => await auth.signOut();
}
