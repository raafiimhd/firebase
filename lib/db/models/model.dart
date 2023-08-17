// import 'package:hive/hive.dart';
// part 'db_models.g.dart';

// @HiveType(typeId: 1)
// class StudentModel{

//   @HiveField(0)
//   final String name;
//   @HiveField(1)
//   final int age;
//   @HiveField(2)
//   final String domain;
//   @HiveField(3)
//   final int contact;
//   @HiveField(4)
//   final String image;

//   StudentModel({
//   required this.name,
//   required this.age,
//   required this.domain,
//   required this.contact,
//   required this.image,
//   });
// }

class StudentModel {
  final String name;
  final String domain;
  final int contact;
  final int age;
  final String id;
  // final String image;

  StudentModel({
    required this.name,
    required this.domain,
    required this.age,
    required this.contact,
    // required this.image
    required this.id
  });
}
