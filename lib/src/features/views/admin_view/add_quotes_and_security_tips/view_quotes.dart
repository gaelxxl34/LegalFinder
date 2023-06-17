import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../constants/edit_quote.dart';
import '../../../authentification/controllers/fetch_data_controller.dart';
import '../../../authentification/models/other_models.dart';


class ViewQuote extends StatefulWidget {
  const ViewQuote({Key? key}) : super(key: key);

  @override
  State<ViewQuote> createState() => _ViewQuoteState();
}

class _ViewQuoteState extends State<ViewQuote> {
  var controller = Get.put(FetchDataController());
  void refreshPage()=> setState(() {});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Quote"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  FutureBuilder<List<Quote_Model>>(
                    future: controller.getQuote(),
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
                            List<Quote_Model> userData = snapshot.data!;
                            return SizedBox(
                              height: 300,
                              child: ListView.builder(
                                itemCount: userData.length,
                                itemBuilder: (BuildContext context, int index) {
                                  Quote_Model user = userData[index];
                                  return Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        height: 145,
                                        child: Image(
                                          image: NetworkImage(user.imageUrl),
                                          fit: BoxFit.cover,

                                        ),
                                      ),
                                      ElevatedButton(
                                          onPressed: (){
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => EditQuote(user: user,  refreshPage: refreshPage,),
                                              ),
                                            );
                                          },
                                          child: Text("Change Quote")
                                      )
                                    ],
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
      ),
    );
  }
}
