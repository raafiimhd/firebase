import 'dart:typed_data';
import 'package:db_me/Widgets/list_student_widgets.dart';
import 'package:db_me/db/functions/db_functions.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';

import 'global.dart';

Uint8List? _cloudFile;

class AddStudentWidget extends StatefulWidget {
  const AddStudentWidget({Key? key}) : super(key: key);

  @override
  State<AddStudentWidget> createState() => _AddStudentWidgetState();
}

class _AddStudentWidgetState extends State<AddStudentWidget> {
  final _formKey = GlobalKey<FormState>();
  bool isVisible = false;

  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _domainController = TextEditingController();
  final _contactController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student view'),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        imagepicker();
                      },
                      child: Stack(
                        children: [
                          _cloudFile == null
                              ? const CircleAvatar(
                                  backgroundColor: Colors.grey,
                                  radius: 50,
                                )
                              : CircleAvatar(
                                  backgroundImage: MemoryImage(_cloudFile!),
                                  radius: 50,
                                ),
                          const Padding(
                            padding: EdgeInsets.only(
                              left: 46,
                              right: 10,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible: isVisible,
                      child: const Text(
                        'Please Add Photo',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    TextFormField(
                      controller: _nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'name',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _ageController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your age';
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'age',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _domainController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'please enter your domain';
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'domain',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _contactController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Enter your number';
                        } else if (value.length != 10) {
                          return 'Number must be 10';
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'contact',
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate() &&
                            _cloudFile != null) {
                          onAddStudentButton();
                          submit();
                        } else {
                          if (_cloudFile == null) {
                            setState(() {
                              isVisible = true;
                            });
                          } else {
                            setState(() {
                              isVisible = false;
                            });
                          }
                        }
                      },
                      child: const Text('Add Student'),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void imagepicker() async {
    final pickedFile = await ImagePickerWeb.getImageAsBytes();

    if (pickedFile != null) {
      setState(() {
        _cloudFile = pickedFile;
      });
    }
  }

  void submit() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
        content: Text('Adding Data...'),
      ),
    );
    await Future.delayed(
      const Duration(seconds: 2),
    );
  }

  Future<void> onAddStudentButton() async {
    final name = _nameController.text.trim();
    final age = _ageController.text.trim();
    final domain = _domainController.text.trim();
    final contact = _contactController.text.trim();
    final firebaseService = FirebaseService();
    bool success = await firebaseService. addStudent(
      name: name,
      age: int.parse(age),
      domain: domain,
      contact: int.parse(contact),
      // image: images!,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
          content: Text('Student added successfully'),
        ),
      );

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) => ListStudentWidget()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
          content: Text('Failed to add student'),
        ),
      );
    }
  }
}
