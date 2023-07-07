

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../../features/authentification/controllers/notification_controller.dart';
import '../../features/authentification/models/other_models.dart';
import '../../features/authentification/models/user_model.dart';

class
UserRepository extends GetxController {
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

  Future<Admin_Lawyer_Model?> getLawyerDetails(String Email) async {
    final snapshot = await _db.collection('Users').where("Email", isEqualTo: Email).get();
    final userData = snapshot.docs.map((e) => Admin_Lawyer_Model.fromSnapshot(e)).single;
    return userData;
  }

  Future<OthersModel?> getOthersDetails(String Email) async {
    final snapshot = await _db.collection('Users').where("Email", isEqualTo: Email).get();
    final userData = snapshot.docs.map((e) => OthersModel.fromSnapshot(e)).single;
    return userData;
  }

  Future<List<Wanted_Criminals_Model>> allPoliceData() async {
    final snapshot = await _db.collection('Police').get();
    final userData = snapshot.docs.map((e) => Wanted_Criminals_Model.fromSnapshot(e)).toList();
    return userData;
  }

  Future<List<Document_Model>> allDocs() async {
    final snapshot = await _db.collection('Judiciary').get();
    final userData = snapshot.docs.map((e) => Document_Model.fromSnapshot(e)).toList();
    return userData;
  }

  Future<List<Document_Model>> allDocx(String email) async {
    final snapshot = await _db
        .collection('Judiciary')
        .where('Email', isEqualTo: email) // Replace 'uid' with the actual field name representing the user identifier
        .get();

    final userData = snapshot.docs.map((e) => Document_Model.fromSnapshot(e)).toList();
    return userData;
  }


  Future<List<Admin_Lawyer_Model>> allLawyer() async {
    final snapshot = await _db
        .collection('Users')
        .where('Role', isEqualTo: 'lawyer') // Assuming 'role' is the field representing the user's role
        .get();
    final userData = snapshot.docs.map((e) => Admin_Lawyer_Model.fromSnapshot(e)).toList();
    return userData;
  }


  Future<List<OthersModel>> allJudiciary() async {
    final snapshot = await _db
        .collection('Users')
        .where('Role', isEqualTo: 'judiciary') // Assuming 'role' is the field representing the user's role
        .get();
    final userData = snapshot.docs.map((e) => OthersModel.fromSnapshot(e)).toList();
    return userData;
  }


  Future<List<OthersModel>> allAdmin() async {
    final snapshot = await _db
        .collection('Users')
        .where('Role', isEqualTo: 'admin') // Assuming 'role' is the field representing the user's role
        .get();
    final userData = snapshot.docs.map((e) => OthersModel.fromSnapshot(e)).toList();
    return userData;
  }


  Future<List<OthersModel>> allPolice() async {
    final snapshot = await _db
        .collection('Users')
        .where('Role', isEqualTo: 'police') // Assuming 'role' is the field representing the user's role
        .get();
    final userData = snapshot.docs.map((e) => OthersModel.fromSnapshot(e)).toList();
    return userData;
  }


  // Document_Model

  createLawyer(Admin_Lawyer_Model uSer) async {
    CollectionReference<Map<String, dynamic>> users = _db.collection("Users");

    // Generate the UID automatically using the doc() method
    DocumentReference<Map<String, dynamic>> docRef = users.doc();
    uSer.uid = docRef.id;

    await docRef.set(uSer.toJson()).whenComplete(
          () => Get.snackbar(
          "Success",
          "Lawyer account has been created",
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


  createOthers(OthersModel uSer) async {
    CollectionReference<Map<String, dynamic>> users = _db.collection("Users");

    // Generate the UID automatically using the doc() method
    DocumentReference<Map<String, dynamic>> docRef = users.doc();
    uSer.uid = docRef.id;

    await docRef.set(uSer.toJson()).whenComplete(
          () => Get.snackbar(
          "Success",
          "Account account has been created",
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



  Future<void> createForPolice(Wanted_Criminals_Model user) async {
    CollectionReference<Map<String, dynamic>> users = _db.collection("Police");

    // Generate the UID automatically using the doc() method
    DocumentReference<Map<String, dynamic>> docRef = users.doc();
    user.uid = docRef.id;

    await docRef.set(user.toJson()).whenComplete(() async {
      // Display success snackbar
      Get.snackbar(
        "Success",
        "Data has been added",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );





    }).catchError((error, stackTrace) {
      // Handle error if Firestore update fails
      Get.snackbar(
        "Error",
        "Something went wrong. Try again",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    });
  }










  createDocument(Document_Model user) async {
    CollectionReference<Map<String, dynamic>> users = _db.collection("Judiciary");

    // Get the email of the authenticated user
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      // User is not authenticated, handle accordingly
      return Get.snackbar("Error", "Something is wrong try again", colorText: Colors.red);
    }
    String email = currentUser.email ?? '';

    // Set the email in the user object
    user.email = email;
    print(email);

    // Generate the UID automatically using the doc() method
    DocumentReference<Map<String, dynamic>> docRef = users.doc();

    await docRef.set(user.toJson()).whenComplete(() {
      Get.snackbar(
        "Success",
        "Document Uploaded",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.1),
        colorText: Colors.green,
      );
    }).catchError((error, stackTrace) {
      Get.snackbar(
        "Error",
        "Something went wrong. Try again",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    });
  }



  createData(LegalCase_Model user) async{
    CollectionReference<Map<String, dynamic>> users = _db.collection("Advices");

    // Generate the UID automatically using the doc() method
    DocumentReference<Map<String, dynamic>> docRef = users.doc();

    await docRef.set(user.toJson()).whenComplete(
          () => Get.snackbar(
          "Success",
          "Data Uploaded",
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



  createTips(Security_Tips_Model user) async{
    CollectionReference<Map<String, dynamic>> users = _db.collection("Tips");

    // Generate the UID automatically using the doc() method
    DocumentReference<Map<String, dynamic>> docRef = users.doc();

    await docRef.set(user.toJson()).whenComplete(
          () => Get.snackbar(
          "Success",
          "Data Uploaded",
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



  createQuote(Quote_Model user) async{
    CollectionReference<Map<String, dynamic>> users = _db.collection("Quote");

    // Generate the UID automatically using the doc() method
    DocumentReference<Map<String, dynamic>> docRef = users.doc();

    await docRef.set(user.toJson()).whenComplete(
          () => Get.snackbar(
          "Success",
          "Data Uploaded",
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

}