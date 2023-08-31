import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentModel extends ChangeNotifier {
  final String? name;
  final String? domain;
  final String? contact;
  final String? age;
  final String? id;
  final String? image;

  StudentModel({
    this.name,
    this.domain,
    this.age,
    this.contact,
     this.image,
    this.id,
  });
 
  factory StudentModel.fromDoc(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return StudentModel(
      id: doc.id,
      name: data['name'] as String,
      domain: data['domain'] as String,
      age: data['age'] as String,
      contact: data['contact'] as String,
      image: data['image'] as String,
    );
  }

  @override
  String toString() {
    return 'StudentModel(id: $id, name: $name, domain: $domain, age: $age, contact: $contact)';
  }

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;

    return o is StudentModel &&
        o.id == id &&
        o.name == name &&
        o.domain == domain &&
        o.age == age &&
        o.contact == contact&&
        o.image == image;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        domain.hashCode ^
        age.hashCode ^
        contact.hashCode;
  }
}
