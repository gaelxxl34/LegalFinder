
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
final _db = FirebaseFirestore.instance;

class UserModel {
  String uid;
  final String fullname;
  final String email;
  String role;
  String fcmToken;

  UserModel({
    this.uid = '',
    required this.fullname,
    required this.email,
    this.role = 'user',
    this.fcmToken = '',
  });

  toJson() {
    return {
      "uid": uid,
      "Fullname": fullname,
      "Email": email,
      "Role": role,
      "fcmToken": fcmToken,
    };
  }

  factory UserModel.fromSnapshot(dynamic snapshot) {
    final data = snapshot.data()!;
    return UserModel(
      uid: snapshot.id,
      fullname: data['Fullname'],
      email: data['Email'],
      role: data['Role'] ?? 'user',
      fcmToken: data['fcmToken'] ?? '',
    );
  }

  void generateRandomFCMToken() {
    final random = Random();
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    const tokenLength = 20;

    String token = '';

    for (var i = 0; i < tokenLength; i++) {
      token += chars[random.nextInt(chars.length)];
    }

    fcmToken = token;
  }
}



class Admin_Lawyer_Model {
  String uid;
  String fullname;
  String email;
  String role;
  String image;
  String field;
  String phone;

  Admin_Lawyer_Model({
    this.uid = '',
    required this.fullname,
    required this.email,
    required this.role,
    required this.image,
    required this.field,
    required this.phone
  });

  Future<void> updateData(String uid, Admin_Lawyer_Model user) async {
    final docRef = _db.collection('Users').doc(uid);
    await docRef.update(user.toJson());
    Get.snackbar("Data", "Updated", colorText: Colors.green);
  }

  Future<void> deleteData(String uid, Admin_Lawyer_Model user) async {
    try {
      // Delete the image from Firebase Storage if it exists
      if (user.image.isNotEmpty) {
        final storageRef = FirebaseStorage.instance.refFromURL(user.image);

        try {
          await storageRef.getDownloadURL();
          await storageRef.delete();
        } catch (e) {
          // Handle the error indicating that the image doesn't exist
          print('Image does not exist in Firebase Storage.');
        }
      }

      // Delete the user document in Firestore
      final docRef = _db.collection('Users').doc(uid);
      await docRef.delete();

      // Perform any desired actions after deleting the data
      Get.snackbar("Data", "Deleted", colorText: Colors.red);
    } catch (e) {
      print('Error deleting user data: $e');
      // Handle the error as needed
    }
  }







  toJson() {
    return {
      "uid" : uid,
      "Fullname": fullname,
      "Email": email,
      "Role": role,
      "Image": image,
      "Field": field,
      "Phone": phone,
    };
  }

  factory Admin_Lawyer_Model.fromSnapshot(dynamic snapshot) {
    final data = snapshot.data()!;
    return Admin_Lawyer_Model(
      uid: snapshot.id,
      fullname: data['Fullname'],
      email: data['Email'],
      role: data['Role'] ?? '',
      image: data['Image'] ?? '',
      field: data['Field'] ?? '',
      phone: data['Phone'] ?? '',
    );
  }
}

class Wanted_Criminals_Model {
  String uid;
  final String name;
  final String suspect;
  final String img;

  Wanted_Criminals_Model({
    this.uid = '',
    required this.name,
    required this.suspect,
    required this.img,
  });

  toJson() {
    return {
      "uid": uid,
      "Name": name,
      "Suspect of": suspect,
      "Image": img,
    };
  }

  Future<void> updateData(String uid, Wanted_Criminals_Model user) async {
    final docRef = _db.collection('Police').doc(uid);
    await docRef.update(user.toJson());
    Get.snackbar("Data", "Updated", colorText: Colors.green);
  }

  Future<void> deleteData(String uid, Wanted_Criminals_Model user) async {
    try {
      // Delete the image from Firebase Storage if it exists
      if (user.img.isNotEmpty) {
        final storageRef = FirebaseStorage.instance.refFromURL(user.img);

        try {
          await storageRef.getDownloadURL();
          await storageRef.delete();
        } catch (e) {
          // Handle the error indicating that the image doesn't exist
          print('Image does not exist in Firebase Storage.');
        }
      }

      // Delete the user document in Firestore
      final docRef = _db.collection('Police').doc(uid);
      await docRef.delete();

      // Perform any desired actions after deleting the data
      Get.snackbar("Data", "Deleted", colorText: Colors.red);
    } catch (e) {
      print('Error deleting user data: $e');
      // Handle the error as needed
    }
  }

  factory Wanted_Criminals_Model.fromSnapshot(dynamic snapshot) {
    final data = snapshot.data();
    if (data == null) {
      throw Exception('No data available for snapshot');
    }
    return Wanted_Criminals_Model(
      uid: snapshot.id,
      name: data['Name'] ?? '',
      suspect: data['Suspect of'] ?? '',
      img: data['Image'] ?? '',
    );
  }
}


class Document_Model {
  final String document;
  final String description;
  String email;
  final String img;
  String uid;

  Document_Model({
    this.img = '',
    required this.description,
    required this.document,
    this.uid = '',
    this.email = ''
  });

  Future<void> updateData(String uid, Document_Model user) async {
    final docRef = _db.collection('Judiciary').doc(uid);
    await docRef.update(user.toJson());
    Get.snackbar("Data", "Updated", colorText: Colors.green);
  }

  Future<void> deleteData(String uid, Document_Model user) async {
    try {
      // Delete the image from Firebase Storage if it exists
      if (user.img.isNotEmpty) {
        final storageRef = FirebaseStorage.instance.refFromURL(user.img);

        try {
          await storageRef.getDownloadURL();
          await storageRef.delete();
        } catch (e) {
          // Handle the error indicating that the image doesn't exist
          print('Image does not exist in Firebase Storage.');
        }
      }

      // Delete the document from Firebase Storage if it exists
      if (user.document.isNotEmpty) {
        final documentRef = FirebaseStorage.instance.refFromURL(user.document);

        try {
          await documentRef.getDownloadURL();
          await documentRef.delete();
        } catch (e) {
          // Handle the error indicating that the document doesn't exist
          print('Document does not exist in Firebase Storage.');
        }
      }

      // Delete the user document in Firestore
      final docRef = _db.collection('Judiciary').doc(uid);
      await docRef.delete();

      // Perform any desired actions after deleting the data
      Get.snackbar("Data", "Deleted", colorText: Colors.red);
    } catch (e) {
      print('Error deleting user data: $e');
      // Handle the error as needed
    }
  }


  toJson() {
    return {
      "Document": document,
      "Description": description,
      "Image": img,
      "uid": uid,
      "Email": email,
    };
  }

  factory Document_Model.fromSnapshot(dynamic snapshot) {
    final data = snapshot.data();
    if (data == null) {
      throw Exception('No data available for snapshot');
    }
    return Document_Model(
      document: data['Document'] ?? '',
      description: data['Description'] ?? '',
      img: data['Image'] ?? '',
      uid: snapshot.id,
      email: data['Email'],
    );
  }
}




class OthersModel {
  String uid;
  final String fullname;
  final String email;
  final String role;
  final String phone;

  OthersModel({
    this.uid = '',
    required this.fullname,
    required this.email,
    required this.role,
    required this.phone,
  });

  Future<void> updateData(String uid, OthersModel user) async {
    final docRef = _db.collection('Users').doc(uid);
    await docRef.update(user.toJson());
    Get.snackbar("Data", "Updated", colorText: Colors.green);
  }

  Future<void> deleteData(String uid, OthersModel user) async {
      // Delete the user document in Firestore
      final docRef = _db.collection('Users').doc(uid);
      await docRef.delete();
  }


  toJson() {
    return {
      "uid" : uid,
      "Fullname": fullname,
      "Email": email,
      "Role": role,
      "Phone": phone,
    };
  }

  factory OthersModel.fromSnapshot(dynamic snapshot) {
    final data = snapshot.data()!;
    return OthersModel(
      uid: snapshot.id,
      fullname: data['Fullname'],
      email: data['Email'],
      role: data['Role'] ?? '',
      phone: data['Phone'] ?? '',
    );
  }
}