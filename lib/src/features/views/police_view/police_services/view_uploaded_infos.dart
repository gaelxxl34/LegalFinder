import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:legalfinder/src/features/views/police_view/police_services/police_edit_data.dart';

import '../../../authentification/controllers/user+details_controller.dart';
import '../../../authentification/models/user_model.dart';

class PoliceUploadedInfo extends StatefulWidget {
  const PoliceUploadedInfo({Key? key}) : super(key: key);

  @override
  State<PoliceUploadedInfo> createState() => _PoliceUploadedInfoState();
}

class _PoliceUploadedInfoState extends State<PoliceUploadedInfo> {


  @override
  Widget build(BuildContext context) {
    void refreshPage()=> setState(() {});
    var controller = Get.put(UserDetailsController());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Uploaded Infos"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [

              FutureBuilder<List<Wanted_Criminals_Model>>(
                future: controller.getAllPoliceData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      List<Wanted_Criminals_Model> userData = snapshot.data!;
                      return SizedBox(
                        height: 550,
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: userData.length,
                          itemBuilder: (context, index) {
                            Wanted_Criminals_Model user = userData[index];
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 200, // Replace with your desired image height
                                    width: 300,
                                    decoration: BoxDecoration(
                                      color: Colors.white54,
                                      image: DecorationImage(
                                        image: NetworkImage(user.img ?? ''),
                                        // fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Name: ${user.name ?? ''}",
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Suspect: ${user.suspect ?? ''}",
                                    style: TextStyle(fontSize: 13),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black12
                                    ),
                                    onPressed: (){
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditPoliceData(user: user, refreshPage: refreshPage,),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Edit"),
                                        Icon(Icons.edit)
                                      ],
                                    ),
                                  )
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
