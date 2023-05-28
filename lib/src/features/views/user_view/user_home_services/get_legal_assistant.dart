

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GetLegalHelpDashboard extends StatelessWidget {
  const GetLegalHelpDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Our Advocate'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(CupertinoIcons.back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16.0),
            _buildLawyerCategory(
              context,
              'Criminal Advocate',
                  () {},
            ),
            const SizedBox(height: 16.0),
            _buildLawyerCategory(
              context,
              'Civil Advocate',
                  () {
                // Navigate to catalog of environmental lawyers
              },
            ),
            const SizedBox(height: 16.0),
            _buildLawyerCategory(
              context,
              'Family Advocate',
                  () {
                // Navigate to catalog of family lawyers
              },
            ),


            const SizedBox(height: 16.0),
            _buildLawyerCategory(
              context,
              'Tax Advocate',
                  () {
                // Navigate to catalog of tax lawyers
              },
            ),
            const SizedBox(height: 16.0),
            _buildLawyerCategory(
              context,
              'Estate Planning Advocate',
                  () {
                // Navigate to catalog of estate planning lawyers
              },
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildLawyerCategory(
      BuildContext context, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 100.0,
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Center(
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline6,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}