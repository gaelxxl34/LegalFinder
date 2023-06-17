

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:intl/intl.dart';

import '../../../authentification/controllers/signup_controller.dart';
import '../../../authentification/models/user_model.dart';

class WantedCriminal extends StatefulWidget {
  const WantedCriminal({Key? key}) : super(key: key);

  @override
  State<WantedCriminal> createState() => _WantedCriminalState();
}


class _WantedCriminalState extends State<WantedCriminal> {
  String selectedImagePath = '';
  final _formKey = GlobalKey<FormState>();
  final controller = Get.put(SignUpController());


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: ()async {
                    selectImage();
                    setState(() {});
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    width: 300,
                    height: 190,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        selectedImagePath == ''
                            ? Icon(
                          Icons.add_a_photo, // Replace with the desired icon
                          size: 170,
                          color: Colors.blue,
                        )
                            : Image(
                          image: FileImage(File(selectedImagePath)) as ImageProvider,
                          height: 150,
                          width: 200,
                        ),
                      ],
                    )
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 10,),
                      Container(
                        width: 300,
                        height: 50,
                        child: TextFormField(
                          controller: controller.name,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter a Name';
                            }
                            if (value.length < 4) {
                              return 'The Name must be at least 3 characters long';
                            }
                            return null; // Return null if the email is valid
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person),
                            prefixIconColor: Colors.black,
                            hintText: 'Name',
                            hintStyle: TextStyle(color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Colors.black),
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Colors.blue),
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 50,
                        width: 300,
                        child: TextFormField(
                          controller: controller.suspect,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Suspected Crime';
                            }
                            if (value.length < 6) {
                              return 'The Suspected Crime must be at least 6 characters long';
                            }
                            return null; // Return null if the email is valid
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.not_interested_outlined),
                            prefixIconColor: Colors.red,
                            hintText: 'Suspected Crime',
                            hintStyle: TextStyle(color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Colors.black),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Colors.blue),
                              borderRadius: BorderRadius.circular(40.0),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      Container(

                        child: ElevatedButton(
                              onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                if (selectedImagePath != '') {
                                  // Upload image to Firebase Storage
                                  String imageUrl = await uploadImageToStorage(
                                      selectedImagePath);
                                  final user = Wanted_Criminals_Model(
                                    name: controller.name.text.trim(),
                                    suspect: controller.suspect.text.trim(),
                                    img: imageUrl,
                                  );

                                  SignUpController.instance.addWantedCriminals(user);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Processing Data'), backgroundColor: Colors.black,),
                                  );
                                } else {
                                  // Show an error message if no image is selected
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Please select an image.')),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Please fill in all the required fields.')),
                                );
                              }
                            },
                            child: Text("Submit")
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


  Future<String> uploadImageToStorage(String imagePath) async {
    try {
      Reference storageRef = FirebaseStorage.instance.ref().child('images');

      // Generate a unique filename using the current timestamp
      String timestamp = DateFormat('yyyyMMddHHmmss').format(DateTime.now());
      String filename = 'image_$timestamp.jpg';

      // Upload the image with the generated filename
      TaskSnapshot snapshot = await storageRef.child(filename).putFile(
          File(imagePath));

      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image to Firebase Storage: $e');
      return '';
    }
  }


  Future selectImage() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 150,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Text(
                      'Select Image From !',
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            selectedImagePath = await selectImageFromGallery();
                            print('Image_Path:-');
                            print(selectedImagePath);
                            if (selectedImagePath != '') {
                              Navigator.pop(context);
                              setState(() {});
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("No Image Selected !"),
                                  ));
                            }
                          },
                          child: Card(
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/gallery.png',
                                      height: 60,
                                      width: 60,
                                    ),
                                    Text('Gallery'),
                                  ],
                                ),
                              )),
                        ),
                        GestureDetector(
                          onTap: () async {
                            selectedImagePath = await selectImageFromCamera();
                            print('Image_Path:-');
                            print(selectedImagePath);

                            if (selectedImagePath != '') {
                              Navigator.pop(context);
                              setState(() {});
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("No Image Captured !"),
                                  ));
                            }
                          },
                          child: Card(
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Image.asset(
                                      'assets/camera.png',
                                      height: 60,
                                      width: 60,
                                    ),
                                    Text('Camera'),
                                  ],
                                ),
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  selectImageFromGallery() async {
    XFile? file = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 10);
    if (file != null) {
      return file.path;
    } else {
      return '';
    }
  }

//
  selectImageFromCamera() async {
    XFile? file = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 10);
    if (file != null) {
      return file.path;
    } else {
      return '';
    }
  }

}