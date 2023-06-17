
import 'package:get/get.dart';

import '../../../repository/authentication_repo/auth_repo.dart';
import '../../../repository/data_repo/data_repository.dart';
import '../../../repository/user_repo/user_repository.dart';
import '../models/other_models.dart';

class FetchDataController extends GetxController{
  static FetchDataController get instance => Get.find();

  final _authRepo = Get.put(AuthentificationRepository());
  final _DataRepo = Get.put(DataRepository());

  Future<List<LegalCase_Model>> getLegalAdvice() async {
    return _DataRepo.allAdvices();
  }

  Future<List<Security_Tips_Model>> getSecurityTips() async {
    return _DataRepo.allTips();
  }

  Future<List<Quote_Model>> getQuote() async {
    return _DataRepo.Quote();
  }
}