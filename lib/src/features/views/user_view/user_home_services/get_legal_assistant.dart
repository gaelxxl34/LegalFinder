

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../authentification/controllers/network_listener.dart';
import '../../../authentification/controllers/user+details_controller.dart';
import '../../../authentification/models/user_model.dart';

class GetLegalHelpDashboard extends StatefulWidget {
  const GetLegalHelpDashboard({Key? key}) : super(key: key);

  @override
  State<GetLegalHelpDashboard> createState() => _GetLegalHelpDashboardState();
}

class _GetLegalHelpDashboardState extends State<GetLegalHelpDashboard> {

  @override
  void initState()  {
    super.initState();
    NetworkListener networkController = Get.put(NetworkListener());
    networkController.addListener(_onNetworkChange);
  }

  void _onNetworkChange() {
    setState(() {
      // Trigger a rebuild when the network status changes
    });
  }

  @override
  void dispose() {
    NetworkListener networkController = Get.find();
    networkController.removeListener(_onNetworkChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(UserDetailsController());
    NetworkListener networkController = Get.find();


    return Scaffold(
      appBar: AppBar(
        title: Text('Our Advocate'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: networkController.hasInternet
          ? SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          return Container(
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
                                    leading: CircleAvatar(
                                        foregroundImage: NetworkImage(user.image),
                                    ),
                                    title: Text(user.fullname),
                                    subtitle: Text("Expertise: ${user.field}"),
                                    trailing: Column(
                                      children: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red
                                          ),
                                          onPressed: (){
                                            launch('tel:' + user.phone);
                                          },
                                          child: Text("Call"),
                                        ),

                                      ],
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
          ]
        ),
      )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('No internet connection'),
          ],
        ),
      ),
    );
  }
}