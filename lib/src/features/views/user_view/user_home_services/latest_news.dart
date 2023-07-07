import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../authentification/controllers/fetch_data_controller.dart';
import '../../../authentification/controllers/network_listener.dart';
import '../../../authentification/controllers/user+details_controller.dart';
import '../../../authentification/models/other_models.dart';
import '../../../authentification/models/user_model.dart';

class News extends StatefulWidget {
  const News({Key? key}) : super(key: key);

  @override
  State<News> createState() => _NewsState();
}

class _NewsState extends State<News> {
  var controller = Get.put(UserDetailsController());
  var controlle = Get.put(FetchDataController());

  @override
  void initState() {
    super.initState();
    NetworkListener networkController = Get.put(NetworkListener());
    networkController.addListener(_onNetworkChange);
  }

  void _onNetworkChange() {
    setState(() {
      // Trigger a rebuild when the network status changes
    });
  }

  @override
  void dispose() {
    NetworkListener networkController = Get.find();
    networkController.removeListener(_onNetworkChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    NetworkListener networkController = Get.find();
    var mediaQuery = MediaQuery.of(context);
    var height = mediaQuery.size.height;
    var width = mediaQuery.size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("News"),
        centerTitle: true,
      ),
      body: networkController.hasInternet
          ? SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Column(
            children: [
              FutureBuilder<List<Quote_Model>>(
                future: controlle.getQuote(),
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
                          height: height * 0.24,
                          child: ListView.builder(
                            itemCount: userData.length,
                            itemBuilder: (BuildContext context, int index) {
                              Quote_Model user = userData[index];
                              return Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: height * 0.24,
                                    child: Image(
                                      image: NetworkImage(user.imageUrl),
                                      fit: BoxFit.fitWidth,
                                    ),
                                  ),
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
              ),
              SizedBox(height: 5,),
              Text("Wanted", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
              SizedBox(height: 5,),
              FutureBuilder<List<Wanted_Criminals_Model>>(
                future: controller.getAllPoliceData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      List<Wanted_Criminals_Model> userData = snapshot.data!;
                      return Container(
                        color: Color(0xFF040D3B),
                        child: SizedBox(
                          height: height * 0.36,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemCount: userData.length,
                            itemBuilder: (context, index) {
                              Wanted_Criminals_Model user = userData[index];
                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                width: width * 0.6,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
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
                                

                                margin: EdgeInsets.only(top: 3, bottom: 3, left: 3),
                                child: Center(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: height * 0.19, // Replace with your desired image height
                                          width: width * 0.8,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(user.img ?? '' ),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "Name: ${user.name ?? ''}",
                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "Suspect: ${user.suspect ?? ''}",
                                          style: TextStyle(fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      print('Error: ${snapshot.error}');
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    } else {
                      return Center(
                        child: Text('No data available'),
                      );
                    }
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),

              SizedBox(height: 15,),
              Text("Security Tips", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),

              FutureBuilder<List<Security_Tips_Model>>(
                future: controlle.getSecurityTips(),
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
                          height: 240,
                          child: ListView.builder(
                            itemCount: userData.length,
                            itemBuilder: (BuildContext context, int index) {
                              Security_Tips_Model user = userData[index];
                              return SizedBox(
                                height: 220,
                                child: ListView(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    SizedBox(
                                      width: width * 1,
                                      height: 200,
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 10, top: 5),
                                        child: Container(

                                          //padding: EdgeInsets.all(10),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  width: double.infinity,
                                                  height: 155,
                                                  child: Image(
                                                    image: NetworkImage(user.imageUrl),
                                                    fit: BoxFit.cover,

                                                  ),
                                                ),
                                                ListTile(
                                                  tileColor: Colors.black12,
                                                  title: Text(user.title),
                                                  subtitle: Text(user.details),
                                                )
                                              ],
                                            ),
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
      )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Check internet connection'),
          ],
        ),
      ),
    );
  }
}

