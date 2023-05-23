



import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../repository/authentication_repo/auth_repo.dart';
import '../user_home_services/get_legal_assistant.dart';

class UserHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Services'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(CupertinoIcons.person_circle,),
          onPressed: () {
            AuthentificationRepository.instance.logout();
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bGround.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: ElevatedButton(
                onPressed: () => Get.to(GetLegalHelpDashboard()),
                style: ElevatedButton.styleFrom(
                  primary: Colors.black.withOpacity(0.5),
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),
                child: Text(
                  'Get Legal Assistance',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 7),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/text.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: Colors.black.withOpacity(0.5),
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),
                child: Text(
                  'Latest Legal News',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 7),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/11.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: Colors.black.withOpacity(0.5),
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),
                child: Text(
                  'Legal Advices',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 7),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/advices.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  primary: Colors.black.withOpacity(0.5),
                  padding: EdgeInsets.symmetric(vertical: 20),
                ),
                child: Text(
                  'Recent Judgement',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}