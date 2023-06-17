import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import '../../../authentification/controllers/signup_controller.dart';
import '../../../authentification/models/other_models.dart';

class AddLegalAdvice extends StatefulWidget {
  const AddLegalAdvice({Key? key}) : super(key: key);

  @override
  State<AddLegalAdvice> createState() => _AddLegalAdviceState();
}

class _AddLegalAdviceState extends State<AddLegalAdvice> {
  final controller = Get.put(SignUpController());
  final _formKey = GlobalKey<FormState>();
  String selectedImagePath = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Legal Advices"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () async {
                    selectImage();
                    setState(() {});
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    width: 300,
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
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
                          size: 140,
                          color: Colors.blue,
                        )
                            : Image(
                          image: FileImage(File(selectedImagePath)) as ImageProvider,
                          height: 160,
                          width: 200,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),

                  ),),
                SizedBox(height: 15),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        width: 300,
                        child: TextFormField(
                          controller: controller.title,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter a Title';
                            }
                            if (value.length < 10) {
                              return 'The Title must be at least 10 characters long';
                            }
                            return null; // Return null if the email is valid
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.title),
                            prefixIconColor: Colors.black,
                            hintText: 'Title',
                            hintStyle: TextStyle(color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Colors.black),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Colors.blue),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Container(
                        width: 300,
                        child: TextFormField(
                          controller: controller.details,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Details';
                            }
                            if (value.length < 20) {
                              return 'Details must be at least 20 characters long';
                            }
                            return null; // Return null if the email is valid
                          },
                          keyboardType: TextInputType.text,

                          textInputAction: TextInputAction.newline,
                          decoration: InputDecoration(

                            prefixIcon: Icon(Icons.details),
                            prefixIconColor: Colors.black,
                            hintText: 'Details',
                            hintStyle: TextStyle(color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Colors.black),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(width: 1, color: Colors.blue),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (selectedImagePath != '') {
                                // Upload image to Firebase Storage
                                String imageUrl = await uploadImageToStorage(
                                    selectedImagePath);
                                final user = LegalCase_Model(
                                  title: controller.title.text.trim(),
                                  details: controller.details.text.trim(),
                                  imageUrl: imageUrl,
                                );

                                SignUpController.instance.addData(user);
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<String> uploadImageToStorage(String imagePath) async {
    try {
      Reference storageRef = FirebaseStorage.instance.ref().child('advice images');

      // Generate a unique filename using the current timestamp
      String timestamp = DateFormat('yyyyMMddHHmmss').format(DateTime.now());
      String filename = 'image_$timestamp.jpg';

      // Upload the image with the generated filename
      TaskSnapshot snapshot =
      await storageRef.child(filename).putFile(File(imagePath));

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
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
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
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
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
