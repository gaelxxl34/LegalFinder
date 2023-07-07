import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../features/authentification/models/user_model.dart';


class AdvocateSearchDelegate extends SearchDelegate<String> {
  final List<Admin_Lawyer_Model> documents;

  AdvocateSearchDelegate(this.documents);

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
                    foregroundImage: NetworkImage(document.image),
                  ),
                  title: Text(document.fullname),
                  subtitle: Text("${document.field} Lawyer"),
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
                              launch('tel:' + document.phone);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.message),
                            color: Colors.blue,
                            onPressed: (){
                              launch('sms:' + document.phone);
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
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final results = searchItems(query);

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final document = results[index];
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
                    foregroundImage: NetworkImage(document.image),
                  ),
                  title: Text(document.fullname),
                  subtitle: Text("${document.field} Lawyer"),
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
                              launch('tel:' + document.phone);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.message),
                            color: Colors.blue,
                            onPressed: (){
                              launch('sms:' + document.phone);
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
    );
  }

  List<Admin_Lawyer_Model> searchItems(String query) {
    if (query.isEmpty) {
      return documents;
    }

    return documents.where((document) {
      return document.fullname.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
