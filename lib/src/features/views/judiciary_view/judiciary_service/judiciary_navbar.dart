import 'package:flutter/material.dart';
import 'package:legalfinder/src/features/views/judiciary_view/judiciary_service/upload_judgement.dart';
import 'package:legalfinder/src/features/views/judiciary_view/judiciary_service/view_uploade_judgement.dart';


class JudiciaryNavbar extends StatefulWidget {
  @override
  _JudiciaryNavbarState createState() => _JudiciaryNavbarState();
}

class _JudiciaryNavbarState extends State<JudiciaryNavbar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _count(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.upload),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.remove_red_eye_outlined),
            label: 'View',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _count(int index) {
    switch (index) {
      case 0:
        return UploadJudgement();
      case 1:
        return ViewUploadedJudgement();
      default:
        return Container();
    }
  }
}