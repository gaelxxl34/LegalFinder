//
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
//
// import 'package:intl/intl.dart';
//
//
// class JudiciaryAddController extends GetxController{
//   static JudiciaryAddController get instance => Get.find();
//
//   String selectedImagePath = '';
//   String _filePath = '';
//   late File _file;
//
//   Future<String> uploadImageToStorage(String imagePath) async {
//     try {
//       Reference storageRef = FirebaseStorage.instance.ref().child('advice images');
//
//       // Generate a unique filename using the current timestamp
//       String timestamp = DateFormat('yyyyMMddHHmmss').format(DateTime.now());
//       String filename = 'image_$timestamp.jpg';
//
//       // Upload the image with the generated filename
//       TaskSnapshot snapshot =
//       await storageRef.child(filename).putFile(File(imagePath));
//
//       String downloadUrl = await snapshot.ref.getDownloadURL();
//       return downloadUrl;
//     } catch (e) {
//       print('Error uploading image to Firebase Storage: $e');
//       return '';
//     }
//   }
//
//
//
//
//   selectImageFromGallery() async {
//     XFile? file = await ImagePicker()
//         .pickImage(source: ImageSource.gallery, imageQuality: 10);
//     if (file != null) {
//       return file.path;
//     } else {
//       return '';
//     }
//   }
//   Future selectImage() {
//     return showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return Dialog(
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20.0)), //this right here
//             child: Container(
//               height: 150,
//               child: Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Column(
//                   children: [
//                     Text(
//                       'Select Image From !',
//                       style: TextStyle(
//                           fontSize: 18.0, fontWeight: FontWeight.bold),
//                     ),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         GestureDetector(
//                           onTap: () async {
//                             selectedImagePath = await selectImageFromGallery();
//                             print('Image_Path:-');
//                             print(selectedImagePath);
//                             if (selectedImagePath != '') {
//                               Navigator.pop(context);
//                               setState(() {});
//                             } else {
//                               ScaffoldMessenger.of(context)
//                                   .showSnackBar(SnackBar(
//                                 content: Text("No Image Selected !"),
//                               ));
//                             }
//                           },
//                           child: Card(
//                               elevation: 5,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Column(
//                                   children: [
//                                     Image.asset(
//                                       'assets/gallery.png',
//                                       height: 60,
//                                       width: 60,
//                                     ),
//                                     Text('Gallery'),
//                                   ],
//                                 ),
//                               )),
//                         ),
//                         GestureDetector(
//                           onTap: () async {
//                             selectedImagePath = await selectImageFromCamera();
//                             print('Image_Path:-');
//                             print(selectedImagePath);
//
//                             if (selectedImagePath != '') {
//                               Navigator.pop(context);
//                               setState(() {});
//                             } else {
//                               ScaffoldMessenger.of(context)
//                                   .showSnackBar(SnackBar(
//                                 content: Text("No Image Captured !"),
//                               ));
//                             }
//                           },
//                           child: Card(
//                               elevation: 5,
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Column(
//                                   children: [
//                                     Image.asset(
//                                       'assets/camera.png',
//                                       height: 60,
//                                       width: 60,
//                                     ),
//                                     Text('Camera'),
//                                   ],
//                                 ),
//                               )),
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           );
//         });
//   }
//   //
//   selectImageFromCamera() async {
//     XFile? file = await ImagePicker()
//         .pickImage(source: ImageSource.camera, imageQuality: 10);
//     if (file != null) {
//       return file.path;
//     } else {
//       return '';
//     }
//   }
//
// }
//
//
//
//
