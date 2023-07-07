

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants/search_for_lawyer.dart';
import '../../../authentification/controllers/network_listener.dart';
import '../../../authentification/controllers/user+details_controller.dart';
import '../../../authentification/models/user_model.dart';

class GetLegalHelpDashboard extends StatefulWidget {
  const GetLegalHelpDashboard({Key? key}) : super(key: key);

  @override
  State<GetLegalHelpDashboard> createState() => _GetLegalHelpDashboardState();
}

class _GetLegalHelpDashboardState extends State<GetLegalHelpDashboard> {

  var controller = Get.put(UserDetailsController());
  late Future<List<Admin_Lawyer_Model>> _documentsFuture;

  @override
  void initState()  {
    super.initState();
    NetworkListener networkController = Get.put(NetworkListener());
    networkController.addListener(_onNetworkChange);
    _documentsFuture = controller.getLawyers();
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

  Future<List<Admin_Lawyer_Model>> fetchDocuments() async {
    // Implement the logic to fetch documents from Firebase
    // and return the list of documents
    // For example:
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Users').get();
    List<Admin_Lawyer_Model> documents = querySnapshot.docs.map((doc) {
      // Create Document_Model objects from Firestore document data
      return Admin_Lawyer_Model(
        image: doc.get('Image'),
        fullname: doc.get('Fullname'),
        field: doc.get('Field'), email: 'Email', role: 'Role', phone: 'Phone',
      );
    }).toList();

    return documents;
  }

  @override
  Widget build(BuildContext context) {

    NetworkListener networkController = Get.find();
    var mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height;
    var width = mediaQuery.size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Our Advocate'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              List<Admin_Lawyer_Model> documents = await _documentsFuture;
              showSearch(
                context: context,
                delegate: AdvocateSearchDelegate(documents),
              );
            },
          ),
        ],
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
                      height: height * 0.88,
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
                                    subtitle: Text("${user.field} Lawyer"),
                                    trailing: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      //mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: Icon(Icons.phone),
                                              color: Colors.red,
                                              onPressed: (){
                                                launch('tel:' + user.phone);
                                              },
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.message),
                                              color: Colors.blue,
                                              onPressed: (){
                                                launch('sms:' + user.phone);
                                              },
                                            ),


                                          ],
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
            Text('Check internet connection'),
          ],
        ),
      ),
    );
  }
}