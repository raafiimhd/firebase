import 'dart:developer';

import 'package:db_me/db/functions/db_functions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../studentviewscreen/list_student_widgets.dart';

class Editpage extends StatefulWidget {
  PlatformFile? imagefile;
  String imapath = '';
  Editpage({
    super.key,
    required this.student,
    required this.index,
  });

  final AddStudentDataToFirebase student;
  final int index;
  @override
  State<Editpage> createState() => _EditpageState();
}

class _EditpageState extends State<Editpage> {
  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController domainController;
  late TextEditingController numberController;
  late AddStudentDataToFirebase data;

  @override
  void initState() {
    nameController = TextEditingController(text: widget.student.studentName);
    ageController = TextEditingController(text: widget.student.studentAge);
    domainController = TextEditingController(text: widget.student.domain);
    numberController =
        TextEditingController(text: widget.student.contactNumber);
    data = AddStudentDataToFirebase(
      docid: widget.student.docid,
      studentName: widget.student.studentName,
      profileImage: widget.student.profileImage,
      studentAge: widget.student.studentAge,
      contactNumber: widget.student.contactNumber,
      domain: widget.student.domain,
    );
    super.initState();
  }

  Future<void> updateStudentInfo() async {
    try {
      // Check if a new image has been selected
      if (widget.imagefile != null) {
        // Upload the new image to Firebase Storage and get the download URL
        final imageUrl = await uploadImagetoFirebaseStorage(widget.imagefile!);

        // Update the student's information in Firestore with the new image URL
        final updatedStudent = AddStudentDataToFirebase(
          docid: widget.student.docid,
          studentName: nameController.text,
          studentAge: ageController.text,
          domain: domainController.text,
          contactNumber: numberController.text,
          profileImage: imageUrl, // Update the profile image URL
        );

        await editStudent(updatedStudent, imageUrl);

        // Show a success message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Student updated successfully.'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate back to the previous screen
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (ctx) => ListStudentWidget()));
      } else {
        //   // Handle the case where no new image is selected but other information is updated
        //   // Update the student's information in Firestore without changing the image URL
        final updatedStudent = AddStudentDataToFirebase(
          docid: widget.student.docid,
          studentName: nameController.text,
          studentAge: ageController.text,
          domain: domainController.text,
          contactNumber: numberController.text,
          profileImage:
              widget.student.profileImage, // Keep the existing image URL
        );

        await editStudent(updatedStudent, widget.student.profileImage);

        //   // Show a success message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Student information updated successfully.'),
            backgroundColor: Colors.green,
          ),
        );

        //   // Navigate back to the previous screen
       Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (ctx) => ListStudentWidget()));
      }
    } catch (e) {
      // Handle errors and show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating student information: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
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

  Future<String> uploadImagetoFirebaseStorage(PlatformFile imageFile) async {
    print('uploadImagetoFirebaseStorage called');

    if (imageFile.bytes == null) {
      print('imageFile.bytes is null');
      return ''; // or handle the error
    }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Page'),
          centerTitle: true,
          backgroundColor: Colors.blue,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios),
          ),
        ),
        body: Column(
          children: [
            Column(
              children: [
                CircleAvatar(
                  radius: 48,
                  child: widget.imagefile == null
                      ? CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(data.profileImage),
                        )
                      : CircleAvatar(
                          radius: 40,
                          backgroundImage:
                              MemoryImage(widget.imagefile!.bytes!),
                        ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await pickImage().then((value) {
                      log('Image File -->> ${widget.imagefile}');
                    });
                  },
                  child: const Icon(Icons.photo_camera_front_outlined),
                )
              ],
            ),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                hintText: 'name',
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: ageController,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                hintText: 'age',
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: domainController,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                hintText: 'domain',
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: numberController,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                hintText: 'contact',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              onPressed: () async {
                await updateStudentInfo();
              },
              icon: const Icon(Icons.save_alt_outlined),
              label: const Text('Save'),
            )
          ],
        ));
  }
}
