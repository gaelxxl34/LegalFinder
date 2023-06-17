import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../authentification/controllers/fetch_data_controller.dart';
import '../../../authentification/models/other_models.dart';
import 'get_legal_assistant.dart';

class LegalAdvices extends StatelessWidget {
   LegalAdvices({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    var controller = Get.put(FetchDataController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Legal Advice',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<List<LegalCase_Model>>(
        future: controller.getLegalAdvice(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasError) {
              print('Error: ${snapshot.error}');
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                List<LegalCase_Model> userData = snapshot.data!;
                return SizedBox(
                  height: 550,
                  child: ListView.builder(
                    itemCount: userData.length,
                    itemBuilder: (BuildContext context, int index) {
                      LegalCase_Model user = userData[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.imageUrl),
                        ),
                        title: Text(user.title),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                padding: EdgeInsets.all(16.0),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(
                                        backgroundImage:
                                        NetworkImage(user.imageUrl),
                                        radius: 50.0,
                                      ),
                                      Text(
                                        user.title,
                                        style: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 16.0),
                                      Text(user.details),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          TextButton(onPressed: ()=> Get.to(()=>GetLegalHelpDashboard()), child: Text("Find a Lawyer", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.blue),)),
                                          Icon(CupertinoIcons.search)
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                );
              } else {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('No data available', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                );
              }
            }
          }
        },
      )
    );
  }
}
