
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../../repository/authentication_repo/auth_repo.dart';
import '../../../repository/user_repo/user_repository.dart';

class AccountDetailsController extends GetxController{
  static AccountDetailsController get instance => Get.find();

  // get user firstname and pass below
  final _authRepo = Get.put(AuthentificationRepository());
  final _userRepo = Get.put(UserRepository());

  //
  // Future<List<Wanted_Criminals_Model>> getLawyers() async {
  //   return _userRepo.allPoliceData();
  // }








}