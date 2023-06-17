import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../authentification/controllers/user+details_controller.dart';
import '../../../authentification/models/user_model.dart';

class RecentJudgement extends StatefulWidget {
  const RecentJudgement({Key? key}) : super(key: key);

  @override
  State<RecentJudgement> createState() => _RecentJudgementState();
}

class _RecentJudgementState extends State<RecentJudgement> {
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(UserDetailsController());
    return Scaffold(
      appBar: AppBar(
        title: Text("Recent Judgement"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10),

          child: Column(
            children: [
              FutureBuilder<List<Document_Model>>(
                future: controller.getDocuments(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      List<Document_Model> userData = snapshot.data!;
                      return SizedBox(
                        height: 550,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: userData.length,
                          itemBuilder: (context, index) {
                            Document_Model user = userData[index];
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      launch(user.document); // Assuming you have a 'documentUrl' property in your Document_Model
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
                                      child: ListTile(
                                        tileColor: Colors.blue,
                                        leading: Container(
                                          height: 70, // Replace with your desired image height
                                          width: 70,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(user.img)
                                              )
                                          ),
                                        ),
                                        title: Text(user.description),
                                        subtitle: Text("Recent"),
                                      ),
                                    ),
                                  ),
                                ],
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