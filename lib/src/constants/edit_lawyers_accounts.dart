import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../features/authentification/models/user_model.dart';

class EditLawyerDetails extends StatefulWidget {
  final Admin_Lawyer_Model user;
  final Function refreshPage;

  EditLawyerDetails({required this.user, required this.refreshPage});
  void performUpdateOrDelete() {
    refreshPage();
  }
  @override
  _EditLawyerDetailsState createState() => _EditLawyerDetailsState();
}

class _EditLawyerDetailsState extends State<EditLawyerDetails> {
  String selectedImagePath = '';
  TextEditingController _fullnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _uid = TextEditingController();
  TextEditingController _role = TextEditingController();

  TextEditingController _phone = TextEditingController();
  TextEditingController _field = TextEditingController();
  // Add controllers for other fields as needed

  @override
  void initState() {
    super.initState();
    _fullnameController.text = widget.user.fullname;
    _emailController.text = widget.user.email;
    _uid.text = widget.user.uid;
    _role.text = widget.user.role;
    _phone.text = widget.user.phone;
    _field.text = widget.user.field;
    // Initialize other controllers with existing user data
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _emailController.dispose();
    _uid.dispose();
    _role.dispose();
    _phone.dispose();
    _field.dispose();
    // Dispose other controllers as needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _imageController = TextEditingController(text: widget.user.image);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Police Account'),
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
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(90),
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
                    TextField(
                      controller: _fullnameController,
                      decoration: InputDecoration(labelText: 'Full Name'),
                    ),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                    ),
                    TextField(
                      controller: _uid,
                      decoration: InputDecoration(labelText: 'Uid'),
                    ),
                    TextField(
                      controller: _role,
                      decoration: InputDecoration(labelText: 'Role'),
                    ),
                    TextField(
                      controller: _field,
                      decoration: InputDecoration(labelText: 'Field'),
                    ),
                    TextField(
                      controller: _phone,
                      decoration: InputDecoration(labelText: 'Phone'),
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
                              String newImageUrl = await uploadImageToStorage(selectedImagePath, widget.user.image);
                              // Update the user data with the new image URL
                              final users = Admin_Lawyer_Model(
                                fullname: _fullnameController.text,
                                email: _emailController.text,
                                role: _role.text,
                                image: newImageUrl,
                                field: _field.text,
                                phone: _phone.text,
                                uid: widget.user.uid,
                              );
                              // Update the user data in Firestore
                              await widget.user.updateData(users.uid, users);
                            } else {
                              // No new image selected, update other user data without changing the image
                              final users = Admin_Lawyer_Model(
                                fullname: _fullnameController.text,
                                email: _emailController.text,
                                role: _role.text,
                                image: widget.user.image,
                                field: _field.text,
                                phone: _phone.text,
                                uid: widget.user.uid,
                              );
                              // Update the user data in Firestore
                              await widget.user.updateData(users.uid, users);
                            }

                            // Perform any desired actions after updating the data
                            Navigator.pop(context);
                            widget.refreshPage();
                          },
                          child: Text('Update User'),
                        ),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () async {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data'), backgroundColor: Colors.black),
                            );
                            final users = Admin_Lawyer_Model(
                              fullname: _fullnameController.text,
                              email: _emailController.text,
                              role: _role.text,
                              image: _imageController.text,
                              field: _field.text,
                              phone: _phone.text,
                              uid: widget.user.uid,
                            );

                            await widget.user.deleteData(users.uid, users);

                            // Perform any desired actions after deleting the data

                            Navigator.pop(context);
                            widget.refreshPage();
                          },
                          child: Text('Delete User'),
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
