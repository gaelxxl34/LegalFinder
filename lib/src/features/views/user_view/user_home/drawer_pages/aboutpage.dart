import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../constants/text.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Uri website = Uri.parse("https://bryanttechspec.com/legaltech");
    final Uri facebook = Uri.parse("https://www.facebook.com/BryantTechSpec/?mibextid=ZbWKwL");
    final Uri insta = Uri.parse("https://instagram.com/bryanttechspectrum?igshid=ZGUzMzM3NWJiOQ==");
    final Uri twitter = Uri.parse("https://twitter.com/BrayantTech?t=hzsMxRqBA6GIu37B9_NC1w&s=09");





    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("About"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(5),
                width: 200,
                height: 170,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/logo.png"),
                        fit: BoxFit.cover
                    ),

              ),),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Text(abouttext, textAlign: TextAlign.center,)
              ),

              SizedBox(
                height: 140,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () async{
                        if (!await launchUrl(website)) {
                          throw Exception('Could not launch $website');
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.only(bottom: 6),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        height: 130,
                        width: 170,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 100,

                              child: Icon(CupertinoIcons.globe, color: Colors.white, size: 60,),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.green,
                              ),
                            ),
                            Text("Website")
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async{
                        if (!await launchUrl(facebook)) {
                          throw Exception('Could not launch $facebook');
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.only(bottom: 6),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        height: 130,
                        width: 170,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 100,

                              child: Icon(Icons.facebook, color: Colors.white, size: 60,),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.blue,
                              ),
                            ),
                            Text("Facebook")
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 140,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () async{
                        if (!await launchUrl(insta)) {
                          throw Exception('Could not launch $insta');
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.only(bottom: 6),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        height: 130,
                        width: 170,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 100,

                              child: Icon(FontAwesomeIcons.instagram, color: Colors.white, size: 60,),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.red,
                              ),
                            ),
                            Text("Instagram")
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async{
                          if (!await launchUrl(twitter)) {
                        throw Exception('Could not launch $twitter');
                        }

                      },
                      child: Container(
                        padding: EdgeInsets.only(bottom: 6),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 7,
                              offset: Offset(0, 3),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        height: 130,
                        width: 170,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: double.infinity,
                              height: 100,

                              child: Icon(FontAwesomeIcons.twitter, color: Colors.blueAccent, size: 60,),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.black,
                              ),
                            ),
                            Text("Twitter")
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
