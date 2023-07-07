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
import '../../user_view/user_home_services/latest_news.dart';
import '../../user_view/user_home_services/library.dart';
import '../drawer_page/lawyer_profile.dart';

class LawyerHomePage extends StatefulWidget {
  const LawyerHomePage({Key? key}) : super(key: key);

  @override
  State<LawyerHomePage> createState() => _LawyerHomePageState();
}

class _LawyerHomePageState extends State<LawyerHomePage> {
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
              future: controller.getLawyerData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    Admin_Lawyer_Model userData = snapshot.data as Admin_Lawyer_Model;
                    return Column(
                      children: [
                        UserAccountsDrawerHeader(

                          accountEmail: Text(uSer.email!),
                          accountName: Text(userData.fullname),
                          currentAccountPicture: CircleAvatar(
                            foregroundImage: NetworkImage(userData.image)
                          ),

                          // currentAccountPicture: Image(image: NetworkImage(userData.image))
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
                onTap: () => Get.to(LawyerProfile())
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
                  image: AssetImage('assets/advices.jpg'),
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
                  image: AssetImage('assets/text.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: ElevatedButton(
                onPressed: ()=> Get.to(LawLibrary()),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black.withOpacity(0.5),
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),
                child: Text(
                  'E-Library',
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
