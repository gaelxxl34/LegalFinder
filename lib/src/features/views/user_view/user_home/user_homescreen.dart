



import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:legalfinder/src/features/views/user_view/user_home/drawer_pages/aboutpage.dart';
import 'package:legalfinder/src/features/views/user_view/user_home/drawer_pages/help.dart';
import 'package:legalfinder/src/features/views/user_view/user_home_services/legal_advices.dart';

import '../../../../repository/authentication_repo/auth_repo.dart';
import '../../../authentification/controllers/user+details_controller.dart';
import '../../../authentification/models/user_model.dart';
import '../user_home_services/get_legal_assistant.dart';
import '../user_home_services/latest_news.dart';
import '../user_home_services/recent_judgement.dart';
import 'drawer_pages/user_profile.dart';

class UserHomePage extends StatefulWidget {
  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  final uSer = FirebaseAuth.instance.currentUser!;
  var controller = Get.put(UserDetailsController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Services'),
        centerTitle: true,
        leading: Builder(builder: (context){
          return IconButton(
            icon: Icon(CupertinoIcons.person_circle,),
            onPressed: () => Scaffold.of(context).openDrawer(),
          );
        })
      ),
      drawer: Drawer(
        child: ListView(
          children: [

            FutureBuilder(
              future: controller.getUserData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    UserModel userData = snapshot.data as UserModel;
                    return Column(
                      children: [
                        UserAccountsDrawerHeader(

                          accountEmail: Text(uSer.email!),
                          accountName: Text(userData.fullname),
                          currentAccountPicture: Icon(CupertinoIcons.person_alt_circle_fill, size: 90, color: Colors.white,),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else {
                    return Center(child: Text('Something went wrong'));
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.verified_user, color: Colors.blue,),
              title: Text("Profile"),
              onTap: () => Get.to(UserInformation())
            ),
            ListTile(
              leading: Icon(CupertinoIcons.info, color: Colors.blue,),
              title: Text("About"),
              onTap: () => Get.to(AboutPage())
            ),
            ListTile(
              leading: Icon(CupertinoIcons.exclamationmark_shield, color: Colors.blue,),
              title: Text("Help"),
              onTap: () => Get.to(HelpPage())
            ),
            SizedBox(height: 15,),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.red, size: 30,),
              title: Text("Logout", style: TextStyle(fontSize: 17),),
              onTap: () {
                AuthentificationRepository.instance.logout();
              },
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[

          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/text.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: ElevatedButton(
                onPressed: () => Get.to(News()),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black.withOpacity(0.5),
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),
                child: Text(
                  'Latest Legal News',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 7),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bGround.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: ElevatedButton(
                onPressed: () => Get.to(GetLegalHelpDashboard()),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black.withOpacity(0.5),
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),
                child: Text(
                  'Get Legal Assistance',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 7),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/11.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: ElevatedButton(
                onPressed: ()=> Get.to(LegalAdvices()),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black.withOpacity(0.5),
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),
                child: Text(
                  'Legal Advices',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 7),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/advices.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: ElevatedButton(
                onPressed: ()=> Get.to(RecentJudgement()),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black.withOpacity(0.5),
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),
                child: Text(
                  'Recent Judgement',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}