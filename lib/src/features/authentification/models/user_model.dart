
import 'package:cloud_firestore/cloud_firestore.dart';


class UserModel {
  String uid;
  final String fullname;
  final String email;
  final String role;

  UserModel({
    this.uid = '',
    required this.fullname,
    required this.email,
    required this.role,
  });

  toJson() {
    return {
      "uid" : uid,
      "Fullname": fullname,
      "Email": email,
      "Role": role,
    };
  }

  factory UserModel.fromSnapshot(dynamic snapshot) {
    final data = snapshot.data()!;
    return UserModel(
      uid: snapshot.id,
      fullname: data['Fullname'],
      email: data['Email'],
      role: data['Role'] ?? '',
    );
  }
}
