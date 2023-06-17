import 'package:flutter/material.dart';
import 'package:legalfinder/src/features/views/admin_view/add_data/add_legaladvice.dart';
import 'package:legalfinder/src/features/views/admin_view/add_data/view_legaladvices.dart';

class AddDataNabar extends StatefulWidget {
  @override
  _AddDataNabarState createState() => _AddDataNabarState();
}

class _AddDataNabarState extends State<AddDataNabar> {
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
        return AddLegalAdvice();
      case 1:
        return ViewLegalAdvices();
      default:
        return Container();
    }
  }
}