import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../../../authentification/models/user_model.dart';

class EditPoliceData extends StatefulWidget {
  final Wanted_Criminals_Model user;
  final Function refreshPage;

  EditPoliceData({required this.user, required this.refreshPage});
  void performUpdateOrDelete()=> refreshPage();
  @override
  _EditPoliceDataState createState() => _EditPoliceDataState();
}

class _EditPoliceDataState extends State<EditPoliceData> {
  String selectedImagePath = '';
  TextEditingController _name = TextEditingController();
  TextEditingController _suspect = TextEditingController();

  // Add controllers for other fields as needed

  @override
  void initState() {
    super.initState();
    _name.text = widget.user.name;
    _suspect.text = widget.user.suspect;

    // Initialize other controllers with existing user data
  }

  @override
  void dispose() {
    _name.dispose();
    _suspect.dispose();

    // Dispose other controllers as needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _imageController = TextEditingController(text: widget.user.img);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              GestureDetector(
                onTap: ()async {
                  selectImage();
                  setState(() {});
                },
                child: Container(
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
                            ? Image.network(
                            _imageController.text,
                          height: 150,
                          width: 200,
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _name,
                      decoration: InputDecoration(labelText: 'Name'),
                    ),
                    TextField(
                      controller: _suspect,
                      decoration: InputDecoration(labelText: 'Suspect of'),
                    ),

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
                              String newImageUrl = await uploadImageToStorage(selectedImagePath, widget.user.img);
                              // Update the user data with the new image URL
                              final users = Wanted_Criminals_Model(
                                name: _name.text,
                                suspect: _suspect.text,
                                img: newImageUrl,
                                uid: widget.user.uid,
                              );
                              // Update the user data in Firestore
                              await widget.user.updateData(users.uid, users);
                            } else {
                              // No new image selected, update other user data without changing the image
                              final users = Wanted_Criminals_Model(
                                name: _name.text,
                                suspect: _suspect.text,
                                img: widget.user.img,
                                uid: widget.user.uid,
                              );
                              // Update the user data in Firestore
                              await widget.user.updateData(users.uid, users);
                            }

                            // Perform any desired actions after updating the data
                            Navigator.pop(context);
                            widget.refreshPage();
                          },
                          child: Text('Update Data'),
                        ),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () async {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data'), backgroundColor: Colors.black),
                            );
                            final users = Wanted_Criminals_Model(
                              name: _name.text,
                              suspect: _suspect.text,
                              img: _imageController.text,
                              uid: widget.user.uid,
                            );

                            await widget.user.deleteData(users.uid, users);

                            // Perform any desired actions after deleting the data

                            Navigator.pop(context);
                            widget.refreshPage();
                          },
                          child: Text('Delete Data'),
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
      Reference storageRef = FirebaseStorage.instance.ref().child('images');

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
