import 'dart:developer';
import 'dart:html' as html;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:db_me/db/models/model.dart';
import 'package:image_picker/image_picker.dart';
ValueNotifier<List<StudentModel>> studentListNotifier = ValueNotifier([]);

class FirebaseService {
  Future<bool> addStudent({
    required String name,
    required String domain,
    required String age,
    // required Uint8List imageBytes,
    required String contact,
    required XFile imageUrl,
  }) async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    CollectionReference students = fireStore.collection('Student');

    try {
      await students.add({
        'name': name,
        'domain': domain,
        'age': age,
        'image': imageUrl, // Store the image URL
        'contact': contact,
      });

      return true;
    }  catch (e) {
  log(e.toString());
  return false; // Handle the error
}
  }
  Future<List<StudentModel>> fetchStudents() async {
    final collection = await FirebaseFirestore.instance.collection('Student');
    final querySnapshot = await collection.get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return StudentModel(
          name: data['name'],
          domain: data['domain'],
          age: data['age'],
          contact: data['contact'],
          image: data['image'],
          id: doc.id);
    }).toList();
  }
}


  // getAllData() async {
  //   final student = await fetchStudents();
  //   studentListNotifier.value = student;
  // }


Future editStudent(StudentModel student, int index) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final data = firestore.collection('Student').doc(student.id);
    await data.update({
      'name': student.name,
      'age': student.age,
      'domain': student.domain,
      'contact': student.contact,
      'image': student.image
    });
    // String imageUrls = '';

    // Upload images to Firebase Storage
    // for (var imageFile in image) {
    // String imgname = image.path.split('/').last.toString();
    // Reference storageRef =
    //     FirebaseStorage.instance.ref().child('images /$imgname');
    // UploadTask uploadTask = storageRef.putFile(File(image.path));
    // // TaskSnapshot taskSnapshot = await uploadTask;
    // // String imageUrl = await taskSnapshot.ref.getDownloadURL();
    // String imageUrl = await storageRef.getDownloadURL();
    // imageUrls.add(imageUrl);
    // }

    // Create a new document in the Firestore collection

    return true;
  } catch (e) {
    print("Error adding student: $e");
    return false;
  }
}

Future<void> delete(String id) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final data = firestore.collection('Student').doc(id);
  await data.delete();
}
