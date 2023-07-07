import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  @override
  Widget build(BuildContext context) {

    final String _emailAddress = 'bryanttechspec@gmail.com';

    Future<void> feedback_or_problem(BuildContext context) async {
      final Uri uri = Uri(
        scheme: 'mailto',
        path: _emailAddress,
        queryParameters: {'subject': 'Enter the subject here{}'},
      );

      if (await canLaunch(uri.toString())) {
        await launch(uri.toString());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error launching email app.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }



    return Scaffold(
      appBar: AppBar(
        title: Text("Help"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              ListTile(
                  leading: Icon(FontAwesomeIcons.message, color: Colors.blue,),
                  title: Text("Send Feedback"),
                  onTap: () {feedback_or_problem(context);}
              ),
              ListTile(
                  leading: Icon(Icons.sync_problem_rounded, color: Colors.red,),
                  title: Text("Report a Problem"),
                  onTap: () {feedback_or_problem(context);}
              ),
            ],
          ),
        ),
      ),
    );
  }
}
