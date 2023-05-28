

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../features/authentification/models/user_model.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;


  // this method is for storing data in firebase
  createUser(UserModel user) async {
    CollectionReference<Map<String, dynamic>> users = _db.collection("Users");

    // Generate the UID automatically using the doc() method
    DocumentReference<Map<String, dynamic>> docRef = users.doc();
    user.uid = docRef.id;

    await docRef.set(user.toJson()).whenComplete(
          () => Get.snackbar(
          "Success",
          "your account has been created",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green),
    )
        .catchError((error, stackTrace) {
      Get.snackbar(
          "Error",
          "Something went wrong. Try again",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red);
      //print(error.toString());
    });
  }


  Future<UserModel?> getUserDetails(String Email) async {
    final snapshot = await _db.collection('Users').where("Email", isEqualTo: Email).get();
    final userData = snapshot.docs.map((e) => UserModel.fromSnapshot(e)).single;
    return userData;

  }

}