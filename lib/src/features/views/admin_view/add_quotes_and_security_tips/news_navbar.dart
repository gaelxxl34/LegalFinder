import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:legalfinder/src/features/views/admin_view/add_quotes_and_security_tips/view_news_page.dart';

import 'add_on_news_page.dart';

class NewsNavbar extends StatefulWidget {
  @override
  _NewsNavbarState createState() => _NewsNavbarState();
}

class _NewsNavbarState extends State<NewsNavbar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _count(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.cloud_upload),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.remove_red_eye_outlined),
            label: 'View Data',
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
        return AddTips();
      case 1:
        return ViewSecurityTips();
      default:
        return Container();
    }
  }
}