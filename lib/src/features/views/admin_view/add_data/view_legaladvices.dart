import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../constants/edit_legal_advices.dart';
import '../../../authentification/controllers/fetch_data_controller.dart';
import '../../../authentification/controllers/user+details_controller.dart';
import '../../../authentification/models/other_models.dart';
import '../../user_view/user_home_services/get_legal_assistant.dart';

class ViewLegalAdvices extends StatefulWidget {
  const ViewLegalAdvices({Key? key}) : super(key: key);

  @override
  State<ViewLegalAdvices> createState() => _ViewLegalAdvicesState();
}

class _ViewLegalAdvicesState extends State<ViewLegalAdvices> {
  var controller = Get.put(FetchDataController());
  void refreshPage()=> setState(() {});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Legal Advices"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                FutureBuilder<List<LegalCase_Model>>(
                  future: controller.getLegalAdvice(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      if (snapshot.hasError) {
                        print('Error: ${snapshot.error}');
                        return Center(
                          child: Text(snapshot.error.toString()),
                        );
                      } else {
                        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                          List<LegalCase_Model> userData = snapshot.data!;
                          return SizedBox(
                            height: 550,
                            child: ListView.builder(
                              itemCount: userData.length,
                              itemBuilder: (BuildContext context, int index) {
                                LegalCase_Model user = userData[index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(user.imageUrl),
                                  ),
                                  title: Text(user.title),
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Container(
                                          padding: EdgeInsets.all(16.0),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage:
                                                  NetworkImage(user.imageUrl),
                                                  radius: 50.0,
                                                ),
                                                Text(
                                                  user.title,
                                                  style: TextStyle(
                                                      fontSize: 19,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                SizedBox(height: 16.0),
                                                Text(user.details),
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: ElevatedButton(
                                                    onPressed: (){
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => EditLegalAdvices(user: user, refreshPage: refreshPage,),
                                                        ),
                                                      );
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Text("Edit"),
                                                        Icon(Icons.edit)
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          );
                        } else {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('No data available', style: TextStyle(color: Colors.red)),
                              ],
                            ),
                          );
                        }
                      }
                    }
                  },
                )


              ],
            ),
          ),
        ),
      ),
    );
  }
}
