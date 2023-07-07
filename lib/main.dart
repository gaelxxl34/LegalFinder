import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:legalfinder/src/constants/colors.dart';
import 'package:legalfinder/src/features/authentification/controllers/network_controller.dart';
import 'package:legalfinder/src/features/authentification/controllers/network_listener.dart';

import 'package:legalfinder/src/repository/authentication_repo/auth_repo.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';

Future <void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Get.putAsync(() async => AuthentificationRepository());
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
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















