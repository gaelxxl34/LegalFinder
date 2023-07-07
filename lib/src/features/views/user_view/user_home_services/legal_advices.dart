import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../constants/search_for_advices.dart';
import '../../../authentification/controllers/fetch_data_controller.dart';
import '../../../authentification/controllers/network_listener.dart';
import '../../../authentification/models/other_models.dart';
import 'get_legal_assistant.dart';

class LegalAdvices extends StatefulWidget {
   LegalAdvices({Key? key}) : super(key: key);

  @override
  State<LegalAdvices> createState() => _LegalAdvicesState();
}

class _LegalAdvicesState extends State<LegalAdvices> {

  var controller = Get.put(FetchDataController());
  late Future<List<LegalCase_Model>> _documentsFuture;

  @override
  void initState() {
    super.initState();
    NetworkListener networkController = Get.put(NetworkListener());
    networkController.addListener(_onNetworkChange);
    _documentsFuture = controller.getLegalAdvice();
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



  Future<List<LegalCase_Model>> fetchDocuments() async {
    // Implement the logic to fetch documents from Firebase
    // and return the list of documents
    // For example:
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Advices').get();
    List<LegalCase_Model> documents = querySnapshot.docs.map((doc) {
      // Create Document_Model objects from Firestore document data
      return LegalCase_Model(
        imageUrl: doc.get('Image'),
        title: doc.get('Title'),
        details: doc.get('Details'),
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
        title: Text(
          'Legal Advice',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              List<LegalCase_Model> documents = await _documentsFuture;
              showSearch(
                context: context,
                delegate: AdvicesSearchDelegate(documents),
              );
            },
          ),
        ],
        centerTitle: true,
      ),
      body: networkController.hasInternet
          ? FutureBuilder<List<LegalCase_Model>>(
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
                  height: height * 1,
                  child: ListView.builder(
                    itemCount: userData.length,
                    itemBuilder: (BuildContext context, int index) {
                      LegalCase_Model user = userData[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(user.imageUrl),
                        ),
                        title: Text(user.title),
                        subtitle: Text("Click for more..."),
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
