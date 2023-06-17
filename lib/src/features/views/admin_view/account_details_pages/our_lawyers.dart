import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants/edit_lawyers_accounts.dart';
import '../../../../repository/user_repo/user_repository.dart';
import '../../../authentification/controllers/user+details_controller.dart';
import '../../../authentification/models/user_model.dart';

class OurLawyers extends StatefulWidget {
  const OurLawyers({Key? key}) : super(key: key);

  @override
  State<OurLawyers> createState() => _OurLawyersState();
}

class _OurLawyersState extends State<OurLawyers> {

  @override
  Widget build(BuildContext context) {
    void refreshPage()=> setState(() {});

    var controller = Get.put(UserDetailsController());
    return Scaffold(
      appBar: AppBar(
        title: Text("Lawyers"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              FutureBuilder<List<Admin_Lawyer_Model>>(
                future: controller.getLawyers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      List<Admin_Lawyer_Model> userData = snapshot.data!;
                      return SizedBox(
                        height: 550,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: userData.length,
                          itemBuilder: (context, index) {
                            Admin_Lawyer_Model user = userData[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditLawyerDetails(user: user, refreshPage: refreshPage),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 1,
                                      blurRadius: 5,
                                      offset: Offset(0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: ListTile(
                                        leading: Container(
                                          height: 70, // Replace with your desired image height
                                          width: 70,
                                          decoration: BoxDecoration(

                                              image: DecorationImage(
                                                  image: NetworkImage(user.image)
                                              )
                                          ),
                                        ),
                                        title: Text(user.fullname),
                                        subtitle: Text("Expertise: ${user.field}"),
                                        trailing: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red
                                          ),
                                          onPressed: (){
                                            launch('tel:' + user.phone);
                                          },
                                          child: Text("Call"),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    } else if (snapshot.hasError) {
                      print('Error: ${snapshot.error}');
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    } else {
                      return Center(
                        child: Text('No data available'),
                      );
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

