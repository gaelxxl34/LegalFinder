import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../repository/authentication_repo/auth_repo.dart';
import '../../../authentification/controllers/user+details_controller.dart';
import '../../../authentification/models/user_model.dart';
import '../../user_view/user_home/drawer_pages/aboutpage.dart';
import '../../user_view/user_home/drawer_pages/help.dart';
import '../../user_view/user_home/drawer_pages/user_profile.dart';
import '../drawer_page/police_profile.dart';
import '../police_services/view_uploaded_infos.dart';
import '../police_services/wanted_criminals.dart';

class PoliceHomePage extends StatefulWidget {
  const PoliceHomePage({Key? key}) : super(key: key);

  @override
  State<PoliceHomePage> createState() => _PoliceHomePageState();
}

class _PoliceHomePageState extends State<PoliceHomePage> {
  final uSer = FirebaseAuth.instance.currentUser!;
  var controller = Get.put(UserDetailsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Services"),
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
              future: controller.getOthersData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    OthersModel userData = snapshot.data as OthersModel;
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
                onTap: ()=> Get.to(PoliceProfile())
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
                  image: AssetImage('assets/court.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: ElevatedButton(
                onPressed: ()=> Get.to(WantedCriminal()),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black.withOpacity(0.5),
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),
                child: Text(
                  'Wanted Criminals',
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
                onPressed: ()=> Get.to(PoliceUploadedInfo()),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black.withOpacity(0.5),
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),
                child: Text(
                  'View Uploaded Infos',
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