import 'dart:html';
import 'package:file_picker/file_picker.dart';
import 'package:db_me/Widgets/list_student_widgets.dart';
import 'package:db_me/db/functions/db_functions.dart';
import 'package:db_me/db/models/model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:universal_html/html.dart';
import 'dart:html' as html;

File? file;

final nameController = TextEditingController();
final ageController = TextEditingController();
final domainController = TextEditingController();
final contactController = TextEditingController();
String? downloadURL;

class AddStudentWidget extends StatefulWidget {
  String? imapath;
   AddStudentWidget({Key? key}) : super(key: key);

  @override
  State<AddStudentWidget> createState() => _AddStudentWidgetState();
}

class _AddStudentWidgetState extends State<AddStudentWidget> {
  XFile? _image;
  final _formKey = GlobalKey<FormState>();
  bool isVisible = false;
  Uint8List webImage = Uint8List(8);
  String selectImage = '';
  PlatformFile? pickedfile;
  
  @override
  Widget build(BuildContext context) {
   double progress = 0.0;
    // uploadToStorage() {
    //   final input = FileUploadInputElement()..accept = 'image/*';
    //   FirebaseStorage fs = FirebaseStorage.instance;
    //   input.click();
    //   input.onChange.listen((event) {
    //     final file = input.files!.first;
    //     print(file.toString());
    //     final reader = FileReader();
    //     reader.readAsDataUrl(file);
    //     reader.onLoadEnd.listen((event) async {
    //       var snapshot = await fs.ref().child('newfile').putBlob(file);
    //       String dowloadImg = await snapshot.ref.getDownloadURL();
    //       setState(() {
    //         downloadURL = dowloadImg;
    //       });
    //     });
    //   });
    // }


    return Scaffold(
      appBar: AppBar(
        title: const Text('Student view'),
        backgroundColor: Colors.blue,
        centerTitle: true,
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
                    Column(
                      children: [
                        CircleAvatar(
                                radius: 48,
                                backgroundImage: NetworkImage(widget.imapath??'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png')),
                        // ? Container(
                        //     height: 100,
                        //     width: 50,
                        // //   )
                        // : Image.network(downloadURL!),
                        ElevatedButton(
                            onPressed: ()async {
                                
                     FilePickerResult? result =
                      await FilePicker.platform.pickFiles();
                  if (result != null) {
                    Uint8List? file = result.files.first.bytes;
                    String filename = result.files.first.name;
                    UploadTask task = FirebaseStorage.instance
                        .ref()
                        .child("files/images$filename")
                        .putData(file!);
                    task.snapshotEvents.listen((event) {
                      setState(() {
                        progress = ((event.bytesTransferred.toDouble() /
                                    event.totalBytes.toDouble()) *
                                100)
                            .roundToDouble();
                        if (progress == 100) {
                          event.ref.getDownloadURL().then((thumbnailUrl) {
                            setState(() {
                              widget.imapath = thumbnailUrl;
                            });
                          }

                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) {
                              //       return UploadVideo(
                              //           drovalueId: dropDownValue!["id"],
                              //           thumbnail: thumbnailUrl);
                              //     },
                              //   ),
                              // ),
                              );
                        }
                      });
                    });
                  }
                },
                            
                            child:
                                const Icon(Icons.photo_camera_front_outlined))
                      ],
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
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate() &&
                            _image != null) {
                          await onAddStudentButton(context, _image!);
                          submit(context);
                        } else {
                          if (_image == null) {
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

  // Future<void> imagepicker() async {
  //   showDialog(
  //     context: context,
  //     builder: (ctx) {
  //       return Center(
  //         child: Container(
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(16),
  //             color: Colors.white,
  //           ),
  //           width: 200,
  //           height: 100,
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //             children: [
  //               GestureDetector(
  //                 onTap: () {
  //                   getImage(ImageSource.camera);
  //                   Navigator.pop(ctx);
  //                 },
  //                 child: const Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Icon(Icons.camera_alt_sharp),
  //                     Text(
  //                       'Camera',
  //                       style: TextStyle(
  //                         decoration: TextDecoration.none,
  //                         fontSize: 10,
  //                         color: Colors.black,
  //                       ),
  //                     )
  //                   ],
  //                 ),
  //               ),
  //               GestureDetector(
  //                 onTap: () {
  //                   getImage(ImageSource.gallery);
  //                   Navigator.pop(ctx);
  //                 },
  //                 child: const Column(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     Icon(Icons.image_search),
  //                     Text(
  //                       'Gallery',
  //                       style: TextStyle(
  //                         decoration: TextDecoration.none,
  //                         fontSize: 10,
  //                         color: Colors.black,
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               )
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  // void getImage(ImageSource source) async {
  //   final image = await ImagePicker().pickImage(source: source);
  //   if (image == null) {
  //     return;
  //   } else {
  //     final imagepath = XFile(image.path);
  //     setState(() {
  //       _image = imagepath;
  //     });
  //   }
  // }

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

  Future<void> onAddStudentButton(BuildContext context, XFile _image) async {
    final name = nameController.text.trim();
    final age = ageController.text.trim();
    final domain = domainController.text.trim();
    final contact = contactController.text.trim();
    final firebaseService = FirebaseService();
    bool success = await firebaseService.addStudent(
      name: name,
      age: age,
      domain: domain,
      contact: contact,
      imageUrl: _image,
      // imageBytes: webImage,
    );

    if (success) {
      List<StudentModel> updatedStudents =
          await FirebaseService().fetchStudents();
      studentListNotifier.value = updatedStudents;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
          content: Text('Student added successfully'),
        ),
      );

      Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) => const ListStudentWidget()));
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
