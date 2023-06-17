import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:legalfinder/src/features/authentification/models/user_model.dart';

import '../../../authentification/controllers/user+details_controller.dart';

class LawyerProfile extends StatelessWidget {
  const LawyerProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(UserDetailsController());

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.chevron_left),
            onPressed: (){
              Navigator.pop(context);
            },
          ),
          title: Text(
            "Personal Details",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(15.0),
              // child: Center(child: Text('sign in as ' + phone.phoneNumber!)),
              child: FutureBuilder(
                future: controller.getLawyerData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      Admin_Lawyer_Model userData = snapshot.data as Admin_Lawyer_Model;
                      return Column(
                        children: [

                          Container(
                            width: 120,
                            height: 110,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              image: DecorationImage(
                                image: NetworkImage(userData.image),
                                fit: BoxFit.cover
                              )
                            ),

                          ),
                          SizedBox(height: 15,),
                          Container(
                            padding: EdgeInsets.all(20),
                            width: double.infinity,
                            height: 310,
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ListTile(
                                    title: Text("Fullname: " , style: TextStyle(fontSize: 18, ),),
                                    subtitle: Text(userData.fullname),
                                  ),
                                  ListTile(
                                    title: Text("Email: " , style: TextStyle(fontSize: 18)),
                                    subtitle: Text(userData.email),
                                  ),
                                  ListTile(
                                    title: Text("Account: " , style: TextStyle(fontSize: 18)),
                                    subtitle: Text(userData.role),
                                  ),
                                  ListTile(
                                    title: Text("Expertise: " , style: TextStyle(fontSize: 18)),
                                    subtitle: Text(userData.field),
                                  ),
                                  ListTile(
                                    title: Text("Uid: " , style: TextStyle(fontSize: 18)),
                                    subtitle: Text(userData.uid),
                                  ),

                                ],
                              ),
                            ),

                          )

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
              )
          ),
        )
    );
  }
}