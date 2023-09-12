import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:db_me/db/functions/db_functions.dart';
import 'package:db_me/presentation/studentdetails/student_details.dart';
import 'package:flutter/material.dart';



class ListStudentWidget extends StatefulWidget {
  // final String? selectedImage;
  const ListStudentWidget({super.key});

  @override
  State<ListStudentWidget> createState() => _ListStudentWidgetState();
}

class _ListStudentWidgetState extends State<ListStudentWidget> {
  @override
  Widget build(BuildContext context) {
    fetchStudents();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Student List'),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: SafeArea(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('StudentDataCollection')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(
                    color: Colors.black,
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData) {
                  return const Text('No data available.');
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (ctx, index) {
                      final data = AddStudentDataToFirebase.fromMap(
                          snapshot.data!.docs[index].data());
                      return ListTile(
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            data.studentName,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        leading: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: CircleAvatar(
                            backgroundImage: 
                            NetworkImage(data.profileImage),
                            radius: 50,
                          ),
                        ),
                        trailing: GestureDetector(
                          onTap: () {
                            _showDialog(ctx, index, data.docid);
                          },
                          child: const Icon(
                            Icons.delete_forever,
                            color: Colors.red,
                            size: 30,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(ctx).push(
                            MaterialPageRoute(
                              builder: (context) => ScreenDetails(
                                student: data,
                                index: index,
                                imagepath: data.profileImage,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              }),
        ));
  }

  Future<void> _showDialog(BuildContext context, int index, String id) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure you want to delete this student?'),
          actions: [
            TextButton(
              onPressed: () async {
                // deleteStudent(index);
                delete(id);
                Navigator.of(context).pop();
                setState(() {});
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }
}
