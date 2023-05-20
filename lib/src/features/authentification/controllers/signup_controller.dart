



import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../repository/authentication_repo/auth_repo.dart';
import '../../../repository/user_repo/user_repository.dart';
import '../models/user_model.dart';

class SignUpController extends GetxController{
  static SignUpController get instance => Get.find();



  // textfield to get the data from the sign up textfield
  late final email = TextEditingController();
  final password = TextEditingController();
  final fullName = TextEditingController();

  final UserRepo = Get.put(UserRepository());

  // call this function from sign up screen and see the magic
  Future<void> createUser(UserModel user) async {
    print(user);
    // await UserRepo.createUser(user);
    // signup(user.email, user.fullname);
  }
  // void signup(String email, String password){
  //   AuthentificationRepository.instance.createUserWithEmailAndPassword(email, password);
  // }
  void log(String email, String password){
    AuthentificationRepository.instance.login(email, password);
  }

  void registerUser(String email, String password, UserModel user){
    AuthentificationRepository.instance.createUserWithEmailAndPassword(email, password, user);
  }

}