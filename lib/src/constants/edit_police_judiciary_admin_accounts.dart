import 'package:flutter/material.dart';

import '../features/authentification/models/user_model.dart';

class EditOtherDetails extends StatefulWidget {
  final OthersModel user;
  final Function refreshPage;

  EditOtherDetails({required this.user, required this.refreshPage});
  void performUpdateOrDelete()=> refreshPage();
  @override
  _EditOtherDetailsState createState() => _EditOtherDetailsState();
}

class _EditOtherDetailsState extends State<EditOtherDetails> {
  TextEditingController _fullnameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _uid = TextEditingController();
  TextEditingController _role = TextEditingController();

  TextEditingController _phone = TextEditingController();
  // Add controllers for other fields as needed

  @override
  void initState() {
    super.initState();
    _fullnameController.text = widget.user.fullname;
    _emailController.text = widget.user.email;
    _uid.text = widget.user.uid;
    _role.text = widget.user.role;
    _phone.text = widget.user.phone;
    // Initialize other controllers with existing user data
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _emailController.dispose();
    _uid.dispose();
    _role.dispose();
    _phone.dispose();
    // Dispose other controllers as needed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
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

                            final users = OthersModel(
                              fullname: _fullnameController.text,
                              email: _emailController.text,
                              role: _role.text,
                              phone: _phone.text,
                              uid: widget.user.uid,
                            );
                            // Update the user data in Firestore
                            await widget.user.updateData(users.uid, users);

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
                            final users = OthersModel(
                              fullname: _fullnameController.text,
                              email: _emailController.text,
                              role: _role.text,
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

}
