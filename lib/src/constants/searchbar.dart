import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../features/authentification/models/user_model.dart';


class DocumentSearchDelegate extends SearchDelegate<String> {
  final List<Document_Model> documents;

  DocumentSearchDelegate(this.documents);

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
          title: Text(document.description),
          leading: Container(
            height: 70, // Replace with your desired image height
            width: 70,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(document.img)
                )
            ),
          ),
          onTap: () {
            launch(document.document);
            // Handle the onTap action for the search results
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
          leading: Container(
            height: 70, // Replace with your desired image height
            width: 70,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(document.img)
                )
            ),
          ),
          title: Text(document.description),
          onTap: () {
            launch(document.document);
            // Handle the onTap action for the search suggestions
          },
        );
      },
    );
  }

  List<Document_Model> searchItems(String query) {
    if (query.isEmpty) {
      return documents;
    }

    return documents.where((document) {
      return document.description.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
