import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'account_details_pages/our_admin.dart';
import 'account_details_pages/our_judiciary_account.dart';
import 'account_details_pages/our_lawyers.dart';
import 'account_details_pages/our_police_accounts.dart';

class AccountsDetails extends StatefulWidget {
  const AccountsDetails({Key? key}) : super(key: key);

  @override
  State<AccountsDetails> createState() => _AccountsDetailsState();
}

class _AccountsDetailsState extends State<AccountsDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Accounts Management"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 16.0),
            _buildLawyerCategory(
              context,
              'Lawyers',
                  () => Get.to(()=> OurLawyers()),
            ),
            const SizedBox(height: 16.0),
            _buildLawyerCategory(
              context,
              'Law Enforcers',
                  ()=> Get.to(()=> OurPoliceStations())
            ),
            const SizedBox(height: 16.0),
            _buildLawyerCategory(
              context,
              'Judiciary',
                  ()=> Get.to(()=> OurJudiciaryAccounts())
            ),


            const SizedBox(height: 16.0),
            _buildLawyerCategory(
              context,
              'Admins',
                  ()=> Get.to(()=> OurAdmin()),
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

