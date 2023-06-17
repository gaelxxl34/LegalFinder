





import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../lawyers_view/lawyer_home/lawyer_homescreen.dart';
import 'admin_account_details.dart';
import 'admin_dashboard.dart';

class AdminNavbar extends StatefulWidget {
  @override
  _AdminNavbarState createState() => _AdminNavbarState();
}

class _AdminNavbarState extends State<AdminNavbar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _count(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Accounts',
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
        return AdminDashboard();
      case 1:
        return AccountsDetails();
      default:
        return Container();
    }
  }
}