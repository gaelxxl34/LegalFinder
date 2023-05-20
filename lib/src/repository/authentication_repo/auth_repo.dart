import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:legalfinder/src/features/views/user_view/user_auth_service/user_login.dart';
import 'package:legalfinder/src/features/views/welcome_screen.dart';

import '../../features/authentification/models/user_model.dart';
import '../../features/views/user_view/user_auth_service/user_email_verification.dart';
import '../../features/views/user_view/user_home_and_services/user_homescreen.dart';
import '../exception_handler/signup_email_password_failure.dart';
import '../user_repo/user_repository.dart';


class AuthentificationRepository extends GetxController{
  static AuthentificationRepository get instance => Get.find();

  // variables
  final _auth = FirebaseAuth.instance;
  late final Rx<User?> firebaseUser;
  final UserRepo = Get.put(UserRepository());
  // var verificationId = ''.obs;

  @override
  void onReady() {
    Future.delayed(Duration(seconds: 5));
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setIniationScreen);
  }

  _setIniationScreen(User? user) {
    user == null ? Get.offAll(() => const WelcomePage()) : Get.offAll(() => UserHomePage());
  }



  Future<void> createUserWithEmailAndPassword(String email, String password, UserModel user) async {
    try{
      CircularProgressIndicator();
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      print("pass this");
      await UserRepo.createUser(user);
      firebaseUser.value != null ? Get.offAll(() =>  UserHomePage()) : Get.offAll(() => const WelcomePage());
    }on FirebaseAuthException catch(e){
      final ex = SignUpWithEmailAndPasswordFailure.code(e.code);
      print('FIREBASE AUTH EXCEPTION -${ex.message}');
      throw ex;
    }catch(_) {
      final ex = SignUpWithEmailAndPasswordFailure();
      print('EXCEPTION -${ex.message}');
      throw ex;
    }
  }
  void login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('logged in.');
      // Perform any additional actions after successful account creation
    } on FirebaseAuthException catch (e) {
      print(email+" "+password);
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




// log out function
  Future<void> logout() async => await _auth.signOut();


}