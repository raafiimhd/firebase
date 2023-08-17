// import 'package:db_me/db/models/model.dart';
// import 'package:flutter/material.dart';
// import 'package:hive_flutter/adapters.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:db_me/db/models/model.dart';
import 'package:flutter/material.dart';

ValueNotifier<List<StudentModel>> studentListNotifier = ValueNotifier([]);

class FirebaseService {
  Future<bool> addStudent({
    required String name,
    required String domain,
    required int age,
    // required Uint8List image,
    required int contact,
  }) async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    CollectionReference students = fireStore.collection('Student');

    try {
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
      await students.add({
        'name': name,
        'domain': domain,
        'age': age,
        // 'images': imageUrl,
        'contact': contact,
      });

      return true;
    } catch (e) {
      print("Error adding student: $e");
      return false;
    }
  }

  // Fetch students from Firestore
//   Future<List<StudentModel>> getStudents() async {
//     print('--------hey');
//     QuerySnapshot<Map<String, dynamic>> querySnapshot = // Specify the type
//         await FirebaseFirestore.instance.collection('students').get();
//     print(querySnapshot.docs);

//     return querySnapshot.docs
//         .map((doc) => StudentModel.fromMap(doc.data()))
//         .toList();
//   }
// }
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
          id: doc.id);
    }).toList();
  }

 getAllData() async {
    final student = await fetchStudents();
    studentListNotifier.value = student;
  }
}

Future editStudent(StudentModel student) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final data = firestore.collection('Student').doc(student.id);
    await data.update({
      'name': student.name,
      'age': student.age,
      'domain': student.domain,
      'contact': student.contact
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

// Future<void> addStudent(StudentModel value) async{
//  final studentDB= await Hive.openBox<StudentModel>('student_db');
//  await studentDB.add(value);


//   studentListNotifier.value.add(value);
//   studentListNotifier.notifyListeners();
// }



// Future<void> getAllStudents() async{
//   final studentDB= await Hive.openBox<StudentModel>('student_db');
//   studentListNotifier.value.clear();

//   studentListNotifier.value.addAll(studentDB.values);
//    studentListNotifier.notifyListeners();
// }

// Future<void> deleteStudent(id) async {
//   final studentDB = await Hive.openBox<StudentModel>('student_db');
//   await studentDB.deleteAt(id);
//   getAllStudents();
// }

