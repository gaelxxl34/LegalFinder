import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import 'dart:io';

import '../../../authentification/controllers/signup_controller.dart';
import '../../../authentification/models/user_model.dart';

class UploadJudgement extends StatefulWidget {
  @override
  _UploadJudgementState createState() => _UploadJudgementState();
}

class _UploadJudgementState extends State<UploadJudgement> {
  final controller = Get.put(SignUpController());
  final _formKey = GlobalKey<FormState>();
  String selectedImagePath = '';
  String _filePath = '';
  late File _file;

  Future<String> uploadDataToStorage(String filePath) async {
    try {
      Reference storageRef = FirebaseStorage.instance.ref().child('documents');

      // Generate a unique filename using the current timestamp
      String timestamp = DateFormat('yyyyMMddHHmmss').format(DateTime.now());
      String filename = 'document_$timestamp.dat';

      // Upload the file with the generated filename
      TaskSnapshot snapshot =
          await storageRef.child(filename).putFile(File(filePath));

      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading data to Firebase Storage: $e');
      return '';
    }
  }

  IconData getFileIcon(String filePath) {
    String extension = filePath.split('.').last.toLowerCase();
    return fileIcons[extension] ??
        Icons.insert_drive_file; // Default icon for unknown file types
  }

  Map<String, IconData> fileIcons = {
    'pdf': Icons.picture_as_pdf,
    'ppt': Icons.slideshow,
    'pptx': Icons.slideshow,
    'doc': Icons.description,
    'docx': Icons.description,
    'xls': Icons.table_chart,
    'xlsx': Icons.table_chart,
    'jpg': Icons.picture_in_picture
    // Add more file extensions and icons as needed
  };

  Future<void> _pickDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'ppt', 'pptx', 'docx', 'doc', 'xls', 'xlsx'],
    );
    if (result != null && result.files.isNotEmpty) {
      _file = File(result.files.first.path!);
      if (await _file.exists()) {
        setState(() {
          _filePath = _file.path;
        });
      } else {
        print('File does not exist');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Upload E-Book'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
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
                              height: 150,
                              width: 170,
                            ),
                          ],
                        ),

                  ),),

              // SizedBox(height: 20),
              SizedBox(
                width: 300,
                child: ElevatedButton(
                  onPressed: _pickDocument,
                  child: Text('Pick Document'),
                ),
              ),
              if (_filePath.isNotEmpty)
                Container(
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

                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            getFileIcon(_file.path),
                            size: 60,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 10),
                          Text(
                            _file.path.split('/').last,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 10),
                          Text(
                            '${(_file.lengthSync() / 1024).toStringAsFixed(2)} KB',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              SizedBox(height: 5),
              Form(
                key: _formKey,
                child: Container(
                  width: 300,
                  height: 45,
                  child: TextFormField(
                    controller: controller.description,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Enter a Description';
                      }
                      if (value.length < 10) {
                        return 'The Description must be at least 10 characters long';
                      }
                      return null; // Return null if the email is valid
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.description_sharp),
                      prefixIconColor: Colors.black,
                      hintText: 'Description',
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
              ),
              SizedBox(height: 20),

              SizedBox(
                width: 300,
                child: ElevatedButton(
                  onPressed: () async {

                    if (_formKey.currentState!.validate()) {

                      if (_filePath != '' && selectedImagePath != '') {
                        // Upload image to Firebase Storage
                        String imageUrl =
                            await uploadImageToStorage(selectedImagePath);
                        // Upload image to Firebase Storage
                        String doc = await uploadDataToStorage(_filePath);
                        final user = Document_Model(
                            description: controller.description.text.trim(),
                            document: doc,
                            img: imageUrl);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data'), backgroundColor: Colors.black,),
                        );
                        SignUpController.instance.addDocument(user);

                      } else {
                        // Show an error message if no image is selected
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Please select an image.')),
                        );
                      }
                    } else {
                      // Show an error message if no image is selected
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Please select the required files. and check if description is added')),
                      );
                    }
                  },
                  child: Text('Upload'),
                ),
              ),
            ],
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
