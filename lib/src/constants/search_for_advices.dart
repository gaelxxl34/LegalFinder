import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../features/authentification/models/other_models.dart';
import '../features/views/user_view/user_home_services/get_legal_assistant.dart';

class AdvicesSearchDelegate extends SearchDelegate<String> {
  final List<LegalCase_Model> documents;

  AdvicesSearchDelegate(this.documents);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = searchItems(query);

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final document = results[index];
        return ListTile(
          title: Text(document.title),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(document.imageUrl),
          ),
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
                          NetworkImage(document.imageUrl),
                          radius: 50.0,
                        ),
                        Text(
                          document.title,
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16.0),
                        Text(document.details),
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
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final results = searchItems(query);

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final document = results[index];
        return ListTile(
          title: Text(document.title),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(document.imageUrl),
          ),
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
                          NetworkImage(document.imageUrl),
                          radius: 50.0,
                        ),
                        Text(
                          document.title,
                          style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 16.0),
                        Text(document.details),
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
    );
  }

  List<LegalCase_Model> searchItems(String query) {
    if (query.isEmpty) {
      return documents;
    }

    return documents.where((document) {
      return document.title.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}