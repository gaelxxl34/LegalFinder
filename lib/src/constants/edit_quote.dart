import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../features/authentification/models/other_models.dart';
import 'dart:io';

class EditQuote extends StatefulWidget {
  final Quote_Model user;
  final Function refreshPage;


  EditQuote({required this.user, required this.refreshPage});
  void performUpdateOrDelete()=> refreshPage();
  @override
  _EditQuoteState createState() => _EditQuoteState();
}

class _EditQuoteState extends State<EditQuote> {
  String selectedImagePath = '';

  // Add controllers for other fields as needed


  @override
  Widget build(BuildContext context) {
    TextEditingController _imageController = TextEditingController(text: widget.user.imageUrl);
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Quote'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              Center(
                child: GestureDetector(
                    onTap: ()async {
                      selectImage();
                      setState(() {});
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(

                          image: selectedImagePath == ''
                              ? NetworkImage(_imageController.text)
                              : FileImage(File(selectedImagePath)) as ImageProvider,
                          fit: BoxFit.fill,
                        ),
                      ),
                    )

                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // Add other fields as needed
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data'), backgroundColor: Colors.black,),
                            );

                            // Check if a new image is selected
                            if (selectedImagePath != '') {
                              // Upload the new image and get the updated image URL
                              String newImageUrl = await uploadImageToStorage(selectedImagePath, widget.user.imageUrl);
                              // Update the user data with the new image URL
                              final users = Quote_Model(
                                imageUrl: newImageUrl,
                                uid: widget.user.uid,
                              );
                              // Update the user data in Firestore
                              await widget.user.updateData(users.uid, users);
                            } else {
                              // No new image selected, update other user data without changing the image
                              final users = Quote_Model(
                                imageUrl: widget.user.imageUrl,
                                uid: widget.user.uid,
                              );
                              // Update the user data in Firestore
                              await widget.user.updateData(users.uid, users);
                            }

                            // Perform any desired actions after updating the data
                            Navigator.pop(context);
                            widget.refreshPage();
                          },
                          child: Text('Update Image'),
                        ),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () async {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data'), backgroundColor: Colors.black),
                            );
                            final users = Quote_Model(
                              imageUrl: _imageController.text,
                              uid: widget.user.uid,
                            );

                            await widget.user.deleteData(users.uid, users);

                            // Perform any desired actions after deleting the data

                            Navigator.pop(context);
                            widget.refreshPage();
                          },
                          child: Text('Delete Image'),
                        ),

                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> uploadImageToStorage(String imagePath, String currentImageUrl) async {
    try {
      print('Deleting existing image...');
      // Delete the existing image if it exists
      if (currentImageUrl.isNotEmpty) {
        await FirebaseStorage.instance.refFromURL(currentImageUrl).delete();
        print('Existing image deleted.');
      } else {
        print('No existing image found.');
      }

      print('Uploading new image...');
      Reference storageRef = FirebaseStorage.instance.ref().child('quote image');

      // Generate a unique filename using the current timestamp
      String timestamp = DateFormat('yyyyMMddHHmmss').format(DateTime.now());
      String filename = 'image_$timestamp.jpg';

      // Upload the new image with the generated filename
      TaskSnapshot snapshot = await storageRef.child(filename).putFile(File(imagePath));
      print('New image uploaded.');

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


}
