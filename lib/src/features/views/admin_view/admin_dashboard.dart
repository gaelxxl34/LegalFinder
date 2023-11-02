import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../repository/authentication_repo/auth_repo.dart';
import '../../authentification/controllers/user+details_controller.dart';
import '../../authentification/models/user_model.dart';
import '../user_view/user_home/drawer_pages/aboutpage.dart';
import '../user_view/user_home/drawer_pages/help.dart';
import '../user_view/user_home/drawer_pages/user_profile.dart';
import 'add_data/Add_data_navbar.dart';
import 'add_data/add_legaladvice.dart';
import 'add_quotes_and_security_tips/news_navbar.dart';
import 'add_quotes_and_security_tips/quote_navbar.dart';
import 'create_accounts/add_admin.dart';
import 'create_accounts/add_librarian.dart';
import 'create_accounts/add_lawyer.dart';
import 'create_accounts/add_police_station.dart';



class AdminDashboard extends StatefulWidget {
   AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final uSer = FirebaseAuth.instance.currentUser!;
  var controller = Get.put(UserDetailsController());


  Map<String, int> roleCount = {
    'Judiciary': 0,
    'Lawyers': 0,
    'Police': 0,
    'Users': 0,
  };

  @override
  void initState() {
    super.initState();
    fetchRoleCounts();
  }

  Future<void> fetchRoleCounts() async {
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('Users').get();
      List<DocumentSnapshot> documents = querySnapshot.docs;
      Map<String, int> counts = {
        'judiciary': 0,
        'lawyer': 0,
        'police': 0,
        'user': 0,
      };
      documents.forEach((doc) {
        String role = doc.get('Role'); // Assuming 'role' is the field in Firestore representing the user's role
        if (counts.containsKey(role)) {
          counts[role] = counts[role]! + 1;
        }
      });

      setState(() {
        roleCount = counts;
      });
    } catch (e) {
      print('Error fetching role counts: $e');
    }
  }




  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height;
    var width = mediaQuery.size.width;



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
            ListTile(
                leading: Icon(CupertinoIcons.info, color: Colors.blue,),
                title: Text("About"),
                onTap: () => Get.to(AboutPage())
            ),
            ListTile(
                leading: Icon(CupertinoIcons.exclamationmark_shield, color: Colors.green,),
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
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text("Welcome! Dear Admin", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 19)),
            SizedBox(height: 15,),
            SizedBox(
            height: height * 0.15,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: () {
                    // Get.to(() => HomeManagement());
                  },
                  child: Container(
                    height: height * 0.15,
                    width: width * 0.465,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: AssetImage('assets/bGround.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: ()=> Get.to(AddLawyer()),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black.withOpacity(0.5),
                        padding: EdgeInsets.symmetric(vertical: 20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(CupertinoIcons.hammer),
                          Text("Add Lawyer")
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Get.to(() => HomeManagement());
                  },
                  child: Container(
                    height: height * 0.15,
                    width: width * 0.465,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: AssetImage('assets/police car.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: ()=> Get.to(AddPoliceStation()),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black.withOpacity(0.5),
                        padding: EdgeInsets.symmetric(vertical: 20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.local_police_outlined),
                          Text("Add Police Station")
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
              SizedBox(height: 7),
            SizedBox(
            height: height * 0.15,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: () {
                    // Get.to(() => HomeManagement());
                  },
                  child: Container(
                    height: height * 0.15,
                    width: width * 0.465,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: AssetImage('assets/admin.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: ()=> Get.to(()=> AddAdmin()),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black.withOpacity(0.5),
                        padding: EdgeInsets.symmetric(vertical: 20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.add_moderator),
                          Text("Add Admin")
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Get.to(() => HomeManagement());
                  },
                  child: Container(
                    height: height * 0.15,
                    width: width * 0.465,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: AssetImage('assets/text.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: ()=>Get.to(AddLibrarian()),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black.withOpacity(0.5),
                        padding: EdgeInsets.symmetric(vertical: 20),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(FontAwesomeIcons.houseFire),
                          Text("Add E-Library")
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
              SizedBox(height: 10),
              Center(child: Text("Statistics", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)),
              SizedBox(height: 10,),

              Container(
                width: double.infinity,
                height: 260,
                decoration: BoxDecoration(
                  color: Color(0xFF040B25),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: PieChart(
                    PieChartData(
                      centerSpaceRadius: 20, // Adjust the radius of the empty space in the middle
                      sectionsSpace: 3,
                      sections: [
                        PieChartSectionData(
                          title: "Judiciary\n${roleCount['judiciary']}",
                          titleStyle: TextStyle(color: Colors.white),
                          value: roleCount['judiciary']?.toDouble() ?? 0,
                          color: Colors.red,
                          radius: 100,
                        ),
                        PieChartSectionData(
                          title: "Lawyer\n${roleCount['lawyer']}",
                          titleStyle: TextStyle(color: Colors.white),
                          value: roleCount['lawyer']?.toDouble() ?? 0,
                          color: Colors.blue,
                          radius: 100,
                        ),
                        PieChartSectionData(
                          title: "Police\n${roleCount['police']}",
                          titleStyle: TextStyle(color: Colors.white),
                          value: roleCount['police']?.toDouble() ?? 0,
                          color: Colors.green,
                          radius: 100,
                        ),
                        PieChartSectionData(
                          title: "User\n${roleCount['user']}",
                          titleStyle: TextStyle(color: Colors.white),
                          value: roleCount['user']?.toDouble() ?? 0,
                          color: Colors.orange,
                          radius: 100,
                        ),
                      ],
                    ),
                  )

                ),
              ),





              SizedBox(height: 10),

              SizedBox(
                height: height * 0.15,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: height * 0.15,
                      width: width * 0.465,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: AssetImage('assets/text.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: ()=> Get.to(()=> AddDataNabar()),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black.withOpacity(0.5),
                          padding: EdgeInsets.symmetric(vertical: 20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.park_rounded),
                            Text("Add Legal Advice")
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: height * 0.15,
                      width: width * 0.465,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: AssetImage('assets/library.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: ()=> Get.to(()=> NewsNavbar()),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black.withOpacity(0.5),
                          padding: EdgeInsets.symmetric(vertical: 20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.privacy_tip_sharp),
                            Text("Add Security Tips", textAlign: TextAlign.center,)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: height * 0.15,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: height * 0.15,
                      width: width * 0.465,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: AssetImage('assets/8.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: ()=> Get.to(()=> QuoteNavbar()),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.black.withOpacity(0.5),
                          padding: EdgeInsets.symmetric(vertical: 20),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(CupertinoIcons.quote_bubble),
                            Text("Add Quote to News Page")
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
          ),
        ),
      ),
    );
  }
}


