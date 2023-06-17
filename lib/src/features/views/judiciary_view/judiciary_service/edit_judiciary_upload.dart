import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../authentification/models/user_model.dart';
import 'dart:io';

class EditDocument extends StatefulWidget {
  final Document_Model user;
  final Function refreshPage;

  EditDocument({required this.user, required this.refreshPage});
  void performUpdateOrDelete()=> refreshPage();


  @override
  _EditDocumentState createState() => _EditDocumentState();
}

class _EditDocumentState extends State<EditDocument> {
  String selectedImagePath = '';

  TextEditingController _desk = TextEditingController();

  // Add controllers for other fields as needed


  @override
  void initState() {
    super.initState();
    _desk.text = widget.user.description;

    // Initialize other controllers with existing user data
  }

  @override
  void dispose() {
    _desk.dispose();

    // Dispose other controllers as needed
    super.dispose();
  }

  String _filePath = '';
  late File _file;

  Future<String> uploadDataToStorage(String filePath, String existingDownloadUrl) async {
    try {
      Reference storageRef = FirebaseStorage.instance.ref().child('documents');

      // Generate a unique filename using the current timestamp
      String timestamp = DateFormat('yyyyMMddHHmmss').format(DateTime.now());
      String filename = 'document_$timestamp.dat';

      // Upload the file with the generated filename
      TaskSnapshot snapshot = await storageRef.child(filename).putFile(File(filePath));

      String newDownloadUrl = await snapshot.ref.getDownloadURL();

      // Delete the existing document if a download URL is provided
      if (existingDownloadUrl.isNotEmpty) {
        Reference existingDocRef = FirebaseStorage.instance.refFromURL(existingDownloadUrl);
        await existingDocRef.delete();
      }

      return newDownloadUrl;
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
    TextEditingController _imageController = TextEditingController(text: widget.user.img);
    TextEditingController _doc = TextEditingController(text: widget.user.document);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit'),
        centerTitle: true,
        automaticallyImplyLeading: false,
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
              SizedBox(height: 10),
              GestureDetector(
                onTap: _pickDocument,
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
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_filePath.isNotEmpty)
                          Column(
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
                        if (_filePath.isEmpty)
                          Column(
                            children: [
                              Icon(
                                Icons.insert_drive_file,
                                size: 60,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 10),
                              Text(
                                widget.user.document,
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),


              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _desk,
                      decoration: InputDecoration(labelText: 'Description'),
                    ),

                    // Add other fields as needed
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data'), backgroundColor: Colors.black),
                            );

                            // Check if a new image is selected
                            if (selectedImagePath != '') {
                              // Upload the new image and get the updated image URL
                              String newImageUrl = await uploadImageToStorage(selectedImagePath, widget.user.img);
                              // Update the user data with the new image URL
                              final users = Document_Model(
                                document: _doc.text,
                                description: _desk.text,
                                img: newImageUrl,
                                uid: widget.user.uid,
                              );
                              // Update the user data in Firestore
                              await widget.user.updateData(users.uid, users);
                            } else {
                              // No new image selected, update other user data without changing the image
                              final users = Document_Model(
                                document: _doc.text,
                                description: _desk.text,
                                img: widget.user.img,
                                uid: widget.user.uid,
                              );
                              // Update the user data in Firestore
                              await widget.user.updateData(users.uid, users);
                            }

                            // Check if a new document is selected
                            if (_filePath.isNotEmpty) {
                              // Upload the new document and get the updated document URL
                              String newDocumentUrl = await uploadDataToStorage(_filePath, widget.user.document);
                              // Update the user data with the new document URL
                              final updatedUsers = Document_Model(
                                document: newDocumentUrl,
                                description: _desk.text,
                                img: widget.user.img,
                                uid: widget.user.uid,
                              );
                              // Update the user data in Firestore
                              await widget.user.updateData(updatedUsers.uid, updatedUsers);
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
                            final users = Document_Model(
                              document: _doc.text,
                              description: _desk.text,
                              img: _imageController.text,
                              uid: widget.user.uid,
                            );

                            await widget.user.deleteData(users.uid, users);

                            // Perform any desired actions after deleting the data

                            Navigator.pop(context);
                          },
                          child: Text('Delete Dcument'),
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
