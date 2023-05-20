
import 'package:cloud_firestore/cloud_firestore.dart';


class UserModel {
  String uid;
  final String fullname;
  final String email;

  UserModel({
    this.uid = '',
    required this.fullname,
    required this.email,
  });

  toJson() {
    return {
      "uid" : uid,
      "Fullname": fullname,
      "Email": email,
    };
  }

  factory UserModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return UserModel(
        uid: document.id,
        fullname: data['Fullname'],
        email: data['Email'],
    );
  }
}
