import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:legalfinder/src/features/views/user_view/user_auth_service/user_login.dart';
import 'package:legalfinder/src/features/views/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/authentification/models/user_model.dart';
import '../../features/views/admin_view/admin_dashboard.dart';
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? role = prefs.getString('Role');
    if (role != null) {
      if (role == 'admin') {
        Get.offAll(() => AdminDashboard());
      } else if (role == 'lawyer') {
// Get.offAll(() => LawyerView());
      } else if (role == 'police') {
// Get.offAll(() => PoliceView());
      } else if (role == 'judiciary') {
// Get.offAll(() => JudiciaryView());
      } else if (role == 'user') {
        Get.offAll(() => UserHomePage());
      } else {
        user == null
            ? Get.offAll(() => WelcomePage())
            : user.emailVerified
                ? Get.offAll(() => UserHomePage())
                : Get.offAll(() => EmailVerification());
      }
    } else {
      if (user != null) {
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('Users')
            .doc(user.email)
            .get();
        if (snapshot.exists && snapshot.data() != null) {
          Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
          String? userRole = data['User'];
          if (userRole != null) {
            await prefs.setString('Role', userRole);
            if (userRole == 'admin') {
              Get.offAll(() => AdminDashboard());
            } else if (userRole == 'lawyer') {
// Get.offAll(() => LawyerView());
            } else if (userRole == 'police') {
// Get.offAll(() => PoliceView());
            } else if (userRole == 'judiciary') {
// Get.offAll(() => JudiciaryView());
            } else if (userRole == 'user') {
              Get.offAll(() => UserHomePage());
            }
          } else {
            user.emailVerified
                ? Get.offAll(() => UserHomePage())
                : Get.offAll(() => EmailVerification());
          }
        } else {
          user.emailVerified
              ? Get.offAll(() => UserHomePage())
              : Get.offAll(() => EmailVerification());
        }
      } else {
        Get.offAll(() => WelcomePage());
      }
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

  Future<void> login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Get.snackbar("Logging", "Successfully", colorText: Colors.green);
      // Perform any additional actions after successful account creation
    } on FirebaseAuthException catch (e) {
      print(email + " " + password);
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else {
        print('Error creating account 1: ${e.message}');
        Get.rawSnackbar(
          messageText: const Text(
            'Wrong Email or password',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
          isDismissible: false,
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red[400]!,
          margin: EdgeInsets.zero,
          snackStyle: SnackStyle.GROUNDED,
        );
      }
    } catch (e) {
      print('Error creating account 2: $e');
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
