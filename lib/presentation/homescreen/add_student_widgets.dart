import 'dart:developer';
import 'dart:html';
// import 'dart:io';

import 'package:db_me/utils/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:db_me/db/functions/db_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:universal_html/html.dart';

File? file;
final nameController = TextEditingController();
final ageController = TextEditingController();
final domainController = TextEditingController();
final contactController = TextEditingController();
String? downloadURL;


class AddStudentWidget extends StatefulWidget {
  String? imapath;
  PlatformFile? imagefile;
  AddStudentWidget({Key? key, this.imagefile}) : super(key: key);

  @override
  State<AddStudentWidget> createState() => _AddStudentWidgetState();
}

class _AddStudentWidgetState extends State<AddStudentWidget> {
  final _formKey = GlobalKey<FormState>();
  bool isVisible = false;
  Uint8List webImage = Uint8List(8);
  String selectImage = '';
  PlatformFile? pickedfile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student view'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
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
                      Column(
                        children: [
                          CircleAvatar(
                            radius: 48,
                          
                            child: widget.imagefile == null
                                ? Text("No Image")
                                
                                : CircleAvatar(
                                    radius: 40,
                                    backgroundImage:
                                        MemoryImage(widget.imagefile!.bytes!),
                                  ),
                          ),
                          
                          // Container(decoration: BoxDecoration(image: DecorationImage(image: widget.imagefile==null?Image.asset(''):Image.memory(Uint8List.fromList(widget.imagefile!.bytes!)))),)wha
                          // ? Container(
                          //     height: 100,
                          //     width: 50,
                          // //   )
                          // : Image.network(downloadURL!),
                          ElevatedButton(
                              onPressed: () async {
                                await pickImage().then((value) {
                                  log('Image File -->> ${widget.imagefile}');
                                });
                              },
                              child:
                                  const Icon(Icons.photo_camera_front_outlined))
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      TextFormField(
                        controller: nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          hintText: 'name',
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        controller: ageController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your age';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          hintText: 'age',
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: domainController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'please enter your domain';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          hintText: 'domain',
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        controller: contactController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter your number';
                          } else if (value.length != 10) {
                            return 'Number must be 10';
                          } else {
                            return null;
                          }
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          hintText: 'contact',
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(33, 150, 243, 1),
                        ),
                        onPressed: () async {
                          print("object");
      
                          if (_formKey.currentState!.validate()) {
                            print("checking");
                            if (widget.imagefile == null) {
                              print("object");
                              showToast(msg: "Please upload Image");
                            } else {
                              await uploadImagetoFirebaseStorage(
                                      widget.imagefile!)
                                  .then((value) async {
                                await addStudentDetails(
                                    nameController.text + ageController.text,
                                    nameController.text,
                                    widget.imapath!,
                                    ageController.text,
                                    contactController.text,
                                    domainController.text,
                                    context);
                                clearFields();
                              });
                            }
                          } else {
                            if (widget.imagefile == null) {
                              print("object");
                              showToast(msg: "Please upload Image");
                            } else {
                              return;
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
      ),
    );
  }

  Future<String> uploadImagetoFirebaseStorage(PlatformFile imageFile) async {
    final storageReference = FirebaseStorage.instance
        .ref()
        .child('images')
        .child('image--')
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
    final uploadTask = await storageReference.putData(imageFile.bytes!);
    final downloadURL = await uploadTask.ref.getDownloadURL();
    widget.imapath = downloadURL;
    return downloadURL;
  }

  Future<void> pickImage() async {
    try {
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);
      if (result == null) return;
      setState(() {
        widget.imagefile = result.files.first;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void submit(BuildContext context) async {
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

  void clearFields() {
    nameController.clear();
    ageController.clear();
    domainController.clear();
    contactController.clear();
    setState(() {
      widget.imagefile = null;
    });
  }
}
