import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LawyerSignUp extends StatelessWidget {
  const LawyerSignUp({Key? key}) : super(key: key);

  final String _emailAddress = 'bryanttechspec@gmail.com';

  Future<void> _sendLicenseEmail(BuildContext context) async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: _emailAddress,
      queryParameters: {'subject': 'Lawyer License Upload and passport photo'},
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

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height;
    var width = mediaQuery.size.width;


    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: width * 1.9,
                height: height * 0.6,
                child: Image(
                  image: AssetImage("assets/lawyer.png"),
                )
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {_sendLicenseEmail(context);},
              child: Text('Upload License'),
            ),
          ],
        ),
      ),
    );
  }
}