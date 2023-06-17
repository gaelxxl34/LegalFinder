import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:legalfinder/src/features/authentification/models/user_model.dart';

import '../../../../common_widgets/paassword_field.dart';
import '../../../authentification/controllers/signup_controller.dart';

class AddLawyer extends StatefulWidget {
  const AddLawyer({Key? key}) : super(key: key);

  @override
  State<AddLawyer> createState() => _AddLawyerState();
}

class _AddLawyerState extends State<AddLawyer> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.put(SignUpController());
  String selectedImagePath = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          // padding: EdgeInsets.only(top: 20),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: ()async {
                            selectImage();
                            setState(() {});
                          },
                      child: Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(90),
                          image: DecorationImage(
                            image: selectedImagePath == ''
                                ? AssetImage('assets/placeholder.png',)
                                : FileImage(File(selectedImagePath)) as ImageProvider,
                            fit: BoxFit.fill,
                          ),
                        ),
                      )

                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter your Fullname';
                                }
                                if (value.length < 6) {
                                  return 'Your Fullname must be at least 8 characters long';
                                }
                                return null; // Return null if the email is valid
                              },
                              controller: controller.fullName,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
                                hintText: 'Full Name',
                                suffixIcon: Icon(CupertinoIcons.textbox, color: Colors.black),
                                hintStyle: TextStyle(color: Colors.black),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1, color: Colors.black),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1, color: Colors.blue),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an email address';
                                }
                                if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null; // Return null if the email is valid
                              },
                              controller: controller.email,
                              keyboardType: TextInputType.emailAddress,
                              maxLines: null,
                              textInputAction: TextInputAction.newline,

                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
                                hintText: 'Email',
                                suffixIcon: Icon(CupertinoIcons.mail, color: Colors.black),
                                hintStyle: TextStyle(color: Colors.black),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1, color: Colors.black),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1, color: Colors.blue),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          PasswordTextField(),
                          const SizedBox(height: 10),
                          Container(
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter a role';
                                }
                                if (value.length < 3) {
                                  return 'The role must be at least 3 characters long';
                                }
                                return null; // Return null if the email is valid
                              },
                              controller: controller.role,
                              decoration: InputDecoration(
                                suffixIcon: Icon(Icons.work_outline, color: Colors.black,),
                                hintText: 'Role',
                                hintStyle: TextStyle(color: Colors.black),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1, color: Colors.black),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1, color: Colors.blue),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 45,
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please Enter a Field of expertise';
                                }
                                if (value.length < 4) {
                                  return 'The field must be at least 3 characters long';
                                }
                                return null; // Return null if the email is valid
                              },
                              controller: controller.field,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
                                suffixIcon: Icon(Icons.domain, color: Colors.black,),
                                hintText: 'Field',
                                hintStyle: TextStyle(color: Colors.black),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1, color: Colors.black),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1, color: Colors.blue),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            height: 45,
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a phone number';
                                }
                                if (!value.startsWith('+256')) {
                                  return 'Please start the phone number with "+256" ';
                                }
                                return null;
                              },
                              controller: controller.phone,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10),
                                suffixIcon: Icon(FontAwesomeIcons.phone, color: Colors.black,),
                                hintText: '+256',
                                hintStyle: TextStyle(color: Colors.black),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1, color: Colors.black),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(width: 1, color: Colors.blue),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),
                          SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.black,
                                    side: BorderSide(color: Colors.black),
                                    padding: EdgeInsets.symmetric(vertical: 15)
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    if (selectedImagePath != '') {
                                      // Upload image to Firebase Storage
                                      String imageUrl = await uploadImageToStorage(selectedImagePath);
                                      final uSer = Admin_Lawyer_Model(
                                        fullname: controller.fullName.text.trim(),
                                        email: controller.email.text.trim(),
                                        role: controller.role.text.trim(),
                                        image: imageUrl,
                                        field: controller.field.text.trim(),
                                        phone: controller.phone.text.trim()
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Processing Data'), backgroundColor: Colors.black,),
                                      );

                                      // Add user to the database
                                      SignUpController.instance.AddLawyer(
                                        controller.email.text.trim(),
                                        controller.password.text.trim(),
                                        uSer,
                                      );

                                      // Show a success message
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Sign-up successful!')),
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

                                child: Text(
                                  "Create Account".toUpperCase(),
                                ),
                              )),


                        ],
                      ),
                    ),
                  )
                ],
              ),
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
      TaskSnapshot snapshot = await storageRef.child(filename).putFile(File(imagePath));

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
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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