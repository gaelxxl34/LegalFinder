

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../features/authentification/models/other_models.dart';

class DataRepository extends GetxController{
  static DataRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<List<LegalCase_Model>> allAdvices() async {
    final snapshot = await _db.collection('Advices').get();
    final userData = snapshot.docs.map((e) => LegalCase_Model.fromSnapshot(e)).toList();
    return userData;
  }


  Future<List<Security_Tips_Model>> allTips() async {
    final snapshot = await _db.collection('Tips').get();
    final userData = snapshot.docs.map((e) => Security_Tips_Model.fromSnapshot(e)).toList();
    return userData;
  }

  Future<List<Quote_Model>> Quote() async {
    final snapshot = await _db.collection('Quote').get();
    final userData = snapshot.docs.map((e) => Quote_Model.fromSnapshot(e)).toList();
    return userData;
  }


}