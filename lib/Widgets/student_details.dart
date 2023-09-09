import 'package:db_me/Widgets/editpage.dart';
import 'package:db_me/db/functions/db_functions.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ScreenDetails extends StatelessWidget {
  ScreenDetails({super.key, required this.student, required this.index,this.imagepath});

  AddStudentDataToFirebase student;
  int index;
  String? imagepath;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Details'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (ctx) => Editpage(
                          student: student,
                          index: index,
                          
                        )));
              },
              icon: Icon(Icons.edit))
        ],
      ),
      body: SafeArea(
        child: Container(
          child: Center(
            child: Column(children: [
              // Text('hhjhhfk'),
              CircleAvatar(
                backgroundImage: NetworkImage(
                  student.profileImage),
                  radius: 48,
              ),
              Text(
                "Name:${student.studentName}",
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              Text(
                'Age:${student.studentAge}',
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                'Domain:${student.domain}',
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                'Conatct:${student.contactNumber}',
                style: const TextStyle(fontSize: 20),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
