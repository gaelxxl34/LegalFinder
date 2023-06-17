import 'package:flutter/material.dart';
import 'package:legalfinder/src/features/views/admin_view/add_quotes_and_security_tips/view_quotes.dart';

import 'add_quote.dart';

class QuoteNavbar extends StatefulWidget {
  @override
  _QuoteNavbarState createState() => _QuoteNavbarState();
}

class _QuoteNavbarState extends State<QuoteNavbar> {
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
        return AddQuote();
      case 1:
        return ViewQuote();
      default:
        return Container();
    }
  }
}