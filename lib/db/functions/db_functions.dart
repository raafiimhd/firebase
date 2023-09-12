// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:db_me/presentation/studentviewscreen/list_student_widgets.dart';
import 'package:db_me/utils/utils.dart';
import 'package:flutter/material.dart';

ValueNotifier<List<AddStudentDataToFirebase>> studentListNotifier = ValueNotifier([]);
//model
class AddStudentDataToFirebase {
  String docid;
  String studentName;
  String profileImage;
  String studentAge;
  String contactNumber;
  String domain;
  AddStudentDataToFirebase({
    required this.docid,
    required this.studentName,
    required this.profileImage,
    required this.studentAge,
    required this.contactNumber,
    required this.domain,
  });

  AddStudentDataToFirebase copyWith({
    String? docid,
    String? studentName,
    String? profileImage,
    String? studentAge,
    String? contactNumber,
    String? domain,
  }) {
    return AddStudentDataToFirebase(
      docid: docid ?? this.docid,
      studentName: studentName ?? this.studentName,
      profileImage: profileImage ?? this.profileImage,
      studentAge: studentAge ?? this.studentAge,
      contactNumber: contactNumber ?? this.contactNumber,
      domain: domain ?? this.domain,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'docid': docid,
      'studentName': studentName,
      'profileImage': profileImage,
      'studentAge': studentAge,
      'contactNumber': contactNumber,
      'domain': domain,
    };
  }

  factory AddStudentDataToFirebase.fromMap(Map<String, dynamic> map) {
    return AddStudentDataToFirebase(
      docid: map['docid'] as String,
      studentName: map['studentName'] as String,
      profileImage: map['profileImage'] as String,
      studentAge: map['studentAge'] as String,
      contactNumber: map['contactNumber'] as String,
      domain: map['domain'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory AddStudentDataToFirebase.fromJson(String source) =>
      AddStudentDataToFirebase.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AddStudentDataToFirebase(docid: $docid, studentName: $studentName, profileImage: $profileImage, studentAge: $studentAge, contactNumber: $contactNumber, domain: $domain)';
  }

  @override
  bool operator ==(covariant AddStudentDataToFirebase other) {
    if (identical(this, other)) return true;

    return other.docid == docid &&
        other.studentName == studentName &&
        other.profileImage == profileImage &&
        other.studentAge == studentAge &&
        other.contactNumber == contactNumber &&
        other.domain == domain;
  }

  @override
  int get hashCode {
    return docid.hashCode ^
        studentName.hashCode ^
        profileImage.hashCode ^
        studentAge.hashCode ^
        contactNumber.hashCode ^
        domain.hashCode;
  }
}
//for adding
Future<void> addStudentDetails(
    String docid,
    String studentName,
    String profileImage,
    String studentAge,
    String contactNumber,
    String domain,
    BuildContext context) async {
  AddStudentDataToFirebase studentDetails = AddStudentDataToFirebase(
      docid: docid,
      studentName: studentName,
      profileImage: profileImage,
      studentAge: studentAge,
      contactNumber: contactNumber,
      domain: domain);
  await FirebaseFirestore.instance
      .collection("StudentDataCollection")
      .doc(docid)
      .set(studentDetails.toMap())
      .then((value) {
    showToast(msg: "Profile added");
    Navigator.of(context).push(
        MaterialPageRoute(builder: (ctx) => ListStudentWidget()));
  });
}
// for updating
Future editStudent(AddStudentDataToFirebase student, String imageUrl) async {
  try {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final data =
        firestore.collection('StudentDataCollection').doc(student.docid);
    await data.update({
      'studentName': student.studentName,
      'studentAge': student.studentAge,
      'contactNumber': student.contactNumber,
      'domain': student.domain,
      'profileImage': imageUrl,
    });
    return true;
  } catch (e) {
    print('Error editing student: $e');
    return false;
  }
}
//for getting data
Future<List<AddStudentDataToFirebase>> fetchStudents() async {
  final collection = FirebaseFirestore.instance.collection('StudentDataCollection');
  final querySnapshot = await collection.get();
  return querySnapshot.docs.map((doc) {
    final data = doc.data();
    return AddStudentDataToFirebase(
      studentName: data['studentName'],
      domain: data['domain'],
      studentAge: data['studentAge'],
      contactNumber: data['contactNumber'],
      profileImage: data['profileImage'],
      docid: doc.id,
    );
  }).toList();
}

Future<void> delete(String id) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final data = firestore.collection('StudentDataCollection').doc(id);
  await data.delete();
}
