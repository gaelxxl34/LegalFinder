import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../authentification/controllers/signup_controller.dart';
import 'dart:io';

import '../../../authentification/models/other_models.dart';

class AddQuote extends StatefulWidget {
  const AddQuote({Key? key}) : super(key: key);

  @override
  State<AddQuote> createState() => _AddQuoteState();
}

class _AddQuoteState extends State<AddQuote> {
  final controller = Get.put(SignUpController());
  String selectedImagePath = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Quote"),
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
                    height: 150,
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
                          size: 100,
                          color: Colors.blue,
                        )
                            : Image(
                          image: FileImage(File(selectedImagePath)) as ImageProvider,
                          height: 130,
                          width: double.infinity,
                        ),
                      ],
                    ),

                  ),),
                ElevatedButton(
                    onPressed: () async {

                      if (selectedImagePath != '') {
                        // Upload image to Firebase Storage
                        String imageUrl = await uploadImageToStorage(
                            selectedImagePath);
                        final user = Quote_Model(
                          imageUrl: imageUrl,
                        );

                        SignUpController.instance.addQuote(user);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data'), backgroundColor: Colors.black,),
                        );
                      } else {
                        // Show an error message if no image is selected
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please select an image.')),
                        );
                      }

                    },
                    child: Text("Submit")
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
      Reference storageRef = FirebaseStorage.instance.ref().child('quote image');

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
                padding: const EdgeInsets.all(10.0),
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
}