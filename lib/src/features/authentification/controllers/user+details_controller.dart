


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../repository/authentication_repo/auth_repo.dart';
import '../../../repository/user_repo/user_repository.dart';

class UserDetailsController extends GetxController{
  static UserDetailsController get instance => Get.find();

  // get user firstname and pass below
  final _authRepo = Get.put(AuthentificationRepository());
  final _userRepo = Get.put(UserRepository());

  getUserData(){
    final Email = _authRepo.firebaseUser.value?.email;
    if(Email != null){
      return _userRepo.getUserDetails(Email);
    } else {
      Get.snackbar("Error", "Something is wrong try again", colorText: Colors.red);
    }
  }


}