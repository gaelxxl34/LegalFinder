
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class JudiciarySignUp extends StatelessWidget {
  const JudiciarySignUp({Key? key}) : super(key: key);

  final String _emailAddress = 'bryanttechspec@gmail.com';

  Future<void> _sendLicenseEmail(BuildContext context) async {
    final Uri uri = Uri(
      scheme: 'mailto',
      path: _emailAddress,
      queryParameters: {'subject': 'Location + Officer in charge'},
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
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: double.infinity,
                height: 250,
                child: Image(
                  image: AssetImage("assets/tribunal.png"),
                )
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: () {
                _sendLicenseEmail(context);
              },
              child: Text('Request for Librarian Account'),
            ),
          ],
        ),
      ),
    );
  }
}