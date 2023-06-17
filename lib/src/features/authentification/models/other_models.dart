

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


final _db = FirebaseFirestore.instance;

class LegalCase_Model {
  String title;
  String details;
  String imageUrl;
  String uid;

  LegalCase_Model({
    required this.title,
    required this.details,
    required this.imageUrl,
    this.uid = '',
  });

  Future<void> updateData(String uid, LegalCase_Model user) async {
    final docRef = _db.collection('Advices').doc(uid);
    await docRef.update(user.toJson());
    Get.snackbar("Data", "Updated", colorText: Colors.green);
  }

  Future<void> deleteData(String uid, LegalCase_Model user) async {
    try {
      // Delete the image from Firebase Storage if it exists
      if (user.imageUrl.isNotEmpty) {
        final storageRef = FirebaseStorage.instance.refFromURL(user.imageUrl);

        try {
          await storageRef.getDownloadURL();
          await storageRef.delete();
        } catch (e) {
          // Handle the error indicating that the image doesn't exist
          print('Image does not exist in Firebase Storage.');
        }
      }

      // Delete the user document in Firestore
      final docRef = _db.collection('Advices').doc(uid);
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
      "Title": title,
      "Details": details,
      "Image": imageUrl,
      "uid" : uid,
    };
  }

  factory LegalCase_Model.fromSnapshot(dynamic snapshot) {
    final data = snapshot.data();
    if (data == null) {
      throw Exception('No data available for snapshot');
    }
    return LegalCase_Model(
      title: data['Title'] ?? '',
      details: data['Details'] ?? '',
      imageUrl: data['Image'] ?? '',
      uid: snapshot.id,
    );
  }
}



class Security_Tips_Model {
  String title;
  String details;
  String imageUrl;
  String uid;

  Security_Tips_Model({
    required this.title,
    required this.details,
    required this.imageUrl,
    this.uid = '',
  });

  Future<void> updateData(String uid, Security_Tips_Model user) async {
    final docRef = _db.collection('Tips').doc(uid);
    await docRef.update(user.toJson());
    Get.snackbar("Data", "Updated", colorText: Colors.green);
  }

  Future<void> deleteData(String uid, Security_Tips_Model user) async {
    try {
      // Delete the image from Firebase Storage if it exists
      if (user.imageUrl.isNotEmpty) {
        final storageRef = FirebaseStorage.instance.refFromURL(user.imageUrl);

        try {
          await storageRef.getDownloadURL();
          await storageRef.delete();
        } catch (e) {
          // Handle the error indicating that the image doesn't exist
          print('Image does not exist in Firebase Storage.');
        }
      }

      // Delete the user document in Firestore
      final docRef = _db.collection('Tips').doc(uid);
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
      "Title": title,
      "Details": details,
      "Image": imageUrl,
      "uid" : uid,
    };
  }

  factory Security_Tips_Model.fromSnapshot(dynamic snapshot) {
    final data = snapshot.data();
    if (data == null) {
      throw Exception('No data available for snapshot');
    }
    return Security_Tips_Model(
      title: data['Title'] ?? '',
      details: data['Details'] ?? '',
      imageUrl: data['Image'] ?? '',
      uid: snapshot.id,
    );
  }
}


class Quote_Model {
  String imageUrl;
  String uid;

  Quote_Model({
    required this.imageUrl,
    this.uid = '',
  });

  Future<void> updateData(String uid, Quote_Model user) async {
    final docRef = _db.collection('Quote').doc(uid);
    await docRef.update(user.toJson());
    Get.snackbar("Data", "Updated", colorText: Colors.green);
  }

  Future<void> deleteData(String uid, Quote_Model user) async {
    try {
      // Delete the image from Firebase Storage if it exists
      if (user.imageUrl.isNotEmpty) {
        final storageRef = FirebaseStorage.instance.refFromURL(user.imageUrl);

        try {
          await storageRef.getDownloadURL();
          await storageRef.delete();
        } catch (e) {
          // Handle the error indicating that the image doesn't exist
          print('Image does not exist in Firebase Storage.');
        }
      }

      // Delete the user document in Firestore
      final docRef = _db.collection('Quote').doc(uid);
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

      "Image": imageUrl,
      "uid" : uid,
    };
  }

  factory Quote_Model.fromSnapshot(dynamic snapshot) {
    final data = snapshot.data();
    if (data == null) {
      throw Exception('No data available for snapshot');
    }
    return Quote_Model(

      imageUrl: data['Image'] ?? '',
      uid: snapshot.id,
    );
  }
}