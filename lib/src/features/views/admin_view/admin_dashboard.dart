import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../repository/authentication_repo/auth_repo.dart';
import '../../authentification/controllers/user+details_controller.dart';
import '../../authentification/models/user_model.dart';
import '../user_view/user_home/drawer_pages/user_profile.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final uSer = FirebaseAuth.instance.currentUser!;
  var controller = Get.put(UserDetailsController());



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
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
                onTap: ()=> Get.to(UserInformation())
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
    );
  }
}
