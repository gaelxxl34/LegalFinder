import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:legalfinder/src/constants/colors.dart';
import 'package:legalfinder/src/features/authentification/controllers/network_controller.dart';
import 'package:legalfinder/src/features/authentification/controllers/network_listener.dart';
import 'package:legalfinder/src/features/authentification/controllers/signup_controller.dart';
import 'package:legalfinder/src/features/authentification/models/user_model.dart';
import 'package:legalfinder/src/features/views/admin_view/admin_dashboard.dart';
import 'package:legalfinder/src/features/views/admin_view/admin_navbar.dart';
import 'package:legalfinder/src/features/views/judiciary_view/judiciary_home/judiciary_homescreen.dart';
import 'package:legalfinder/src/features/views/lawyers_view/lawyer_home/lawyer_homescreen.dart';
import 'package:legalfinder/src/features/views/police_view/police_home/police_homscreen.dart';
import 'package:legalfinder/src/features/views/user_view/user_home/user_homescreen.dart';
import 'package:legalfinder/src/features/views/welcome_screen.dart';
import 'package:legalfinder/src/repository/authentication_repo/auth_repo.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '';
import 'firebase_options.dart';

Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Get.putAsync(() async => AuthentificationRepository());
  runApp(
    ChangeNotifierProvider(
      create: (context) => NetworkListener(),
      child: MyApp(),
    ),
  );
}




class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: primary,
      ),
      home: Scaffold(
        bottomSheet: NetworkController(),
      ),
    );

  }
}















