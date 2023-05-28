import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:legalfinder/src/constants/colors.dart';
import 'package:legalfinder/src/features/authentification/controllers/signup_controller.dart';
import 'package:legalfinder/src/features/authentification/models/user_model.dart';
import 'package:legalfinder/src/features/views/admin_view/admin_dashboard.dart';
import 'package:legalfinder/src/features/views/user_view/user_home/user_homescreen.dart';
import 'package:legalfinder/src/features/views/welcome_screen.dart';
import 'package:legalfinder/src/repository/authentication_repo/auth_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '';
import 'firebase_options.dart';

Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Get.putAsync(() async => AuthentificationRepository());
  runApp(MyApp());
}




class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        primarySwatch: primary,
      ),
      home: Scaffold(
        body: FutureBuilder(
          future: getUserRole(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                String? userRole = snapshot.data;

                // Check if the user is logged in.
                final auth = FirebaseAuth.instance;
                if (auth.currentUser != null) {

                  // Switch on the role and navigate to the corresponding screen.
                  switch (userRole) {
                    case 'user':
                      return UserHomePage();
                    case 'admin':
                      return AdminDashboard();
                    case 'lawyer':
                    // return LawyerController();
                    case 'police':
                    // return PoliceController();
                    case 'judiciary':
                    // return JudiciaryController();
                    default:
                      print("there is an error we go to welcome screnn //////////////////////////99999999999999");
                      return WelcomePage();
                  }
                } else {
                  return WelcomePage();
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );

  }
}


Future<String?> getUserRole() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    return null;
  }

  QuerySnapshot snapshot = await FirebaseFirestore.instance
      .collection('Users')
      .where('Email', isEqualTo: user.email)
      .get();

  if (snapshot.docs.isEmpty) {
    return null;
  }

  DocumentSnapshot userSnapshot = snapshot.docs[0];
  return userSnapshot['Role'];
}













