
import 'package:db_me/db/models/db_models.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

ValueNotifier<List<StudentModel>>studentListNotifier=ValueNotifier([]);

Future<void> addStudent(StudentModel value) async{
 final studentDB= await Hive.openBox<StudentModel>('student_db');
 await studentDB.add(value);


  studentListNotifier.value.add(value);
  studentListNotifier.notifyListeners();
}

Future<void> getAllStudents() async{
  final studentDB= await Hive.openBox<StudentModel>('student_db');
  studentListNotifier.value.clear();

  studentListNotifier.value.addAll(studentDB.values);
   studentListNotifier.notifyListeners();
}

Future<void> deleteStudent(id) async {
  final studentDB = await Hive.openBox<StudentModel>('student_db');
  await studentDB.deleteAt(id);
  getAllStudents();
}