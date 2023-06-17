import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../authentification/controllers/user+details_controller.dart';
import '../../../authentification/models/user_model.dart';
import 'edit_judiciary_upload.dart';

class ViewUploadedJudgement extends StatefulWidget {
  const ViewUploadedJudgement({Key? key}) : super(key: key);

  @override
  State<ViewUploadedJudgement> createState() => _ViewUploadedJudgementState();
}

class _ViewUploadedJudgementState extends State<ViewUploadedJudgement> {
  @override
  Widget build(BuildContext context) {
    void refreshPage()=> setState(() {});

    var controller = Get.put(UserDetailsController());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("View Document"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
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
                              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      launch(user.document); // Assuming you have a 'documentUrl' property in your Document_Model
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
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
                                        trailing: IconButton(
                                          onPressed: () async{
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => EditDocument(user: user, refreshPage: refreshPage),
                                              ),
                                            );

                                          },
                                          icon: Icon(Icons.edit, color: Colors.red,),
                                          
                                        ),
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
