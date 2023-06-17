import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../constants/edit_security_tips.dart';
import '../../../authentification/controllers/fetch_data_controller.dart';
import '../../../authentification/models/other_models.dart';

class ViewSecurityTips extends StatefulWidget {
  const ViewSecurityTips({Key? key}) : super(key: key);

  @override
  State<ViewSecurityTips> createState() => _ViewSecurityTipsState();
}

class _ViewSecurityTipsState extends State<ViewSecurityTips> {
  var controller = Get.put(FetchDataController());
  void refreshPage()=> setState(() {});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Security Tips"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                FutureBuilder<List<Security_Tips_Model>>(
                  future: controller.getSecurityTips(),
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
                          List<Security_Tips_Model> userData = snapshot.data!;
                          return SizedBox(
                            height: 550,
                            child: ListView.builder(
                              itemCount: userData.length,
                              itemBuilder: (BuildContext context, int index) {
                                Security_Tips_Model user = userData[index];
                                return SizedBox(
                                  height: 550,
                                  child: ListView(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    children: [
                                      SizedBox(
                                        width: 360,
                                        height: 250,
                                        child: Padding(
                                          padding: const EdgeInsets.only(right: 10, top: 5),
                                          child: Container(

                                            //padding: EdgeInsets.all(10),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: double.infinity,
                                                  height: 145,
                                                  child: Image(
                                                    image: NetworkImage(user.imageUrl),
                                                    fit: BoxFit.cover,

                                                  ),
                                                ),
                                                ListTile(
                                                  tileColor: Colors.black12,
                                                  title: Text(user.title),
                                                  subtitle: Text(user.details),
                                                  trailing: IconButton(
                                                    onPressed: (){
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => EditSecurityTips(user: user,  refreshPage: refreshPage,),
                                                        ),
                                                      );
                                                    },
                                                    icon: Icon(Icons.edit_sharp, color: Colors.red,),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
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
