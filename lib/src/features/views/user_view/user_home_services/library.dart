import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../constants/searchbar.dart';
import '../../../authentification/controllers/network_listener.dart';
import '../../../authentification/controllers/user+details_controller.dart';
import '../../../authentification/models/user_model.dart';

class LawLibrary extends StatefulWidget {
  const LawLibrary({Key? key}) : super(key: key);

  @override
  State<LawLibrary> createState() => _LawLibraryState();
}

class _LawLibraryState extends State<LawLibrary> {
  var controller = Get.put(UserDetailsController());

  late Future<List<Document_Model>> _documentsFuture;

  @override
  void initState() {
    super.initState();
    NetworkListener networkController = Get.put(NetworkListener());
    networkController.addListener(_onNetworkChange);
    _documentsFuture = controller.getDocuments();
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


  Future<List<Document_Model>> fetchDocuments() async {
    // Implement the logic to fetch documents from Firebase
    // and return the list of documents
    // For example:
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Judiciary').get();
    List<Document_Model> documents = querySnapshot.docs.map((doc) {
      // Create Document_Model objects from Firestore document data
      return Document_Model(
        img: doc.get('Image'),
        description: doc.get('Description'),
        document: doc.get('Document'),
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
        title: Text("Law Library"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              List<Document_Model> documents = await _documentsFuture;
              showSearch(
                context: context,
                delegate: DocumentSearchDelegate(documents),
              );
            },
          ),
        ],
      ),
      body: networkController.hasInternet
          ? SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5),

          child: Column(
            children: [
              FutureBuilder<List<Document_Model>>(
                future: controller.getDocuments(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      List<Document_Model> userData = snapshot.data!;
                      return SizedBox(
                        height: height * 0.88,
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
                                          height: 100, // Replace with your desired image height
                                          width: 70,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                  image: NetworkImage(user.img),
                                              )
                                          ),
                                        ),
                                        title: Text(user.description),
                                        subtitle: Text("Click to open"),
                                        trailing: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Icon(CupertinoIcons.book_solid, color: Colors.blue,),
                                            Icon(Icons.star_outlined, color: Colors.green,)
                                          ],
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
      )    : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('check internet connection'),
          ],
        ),
      ),
    );
  }
}

