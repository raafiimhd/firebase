import 'package:db_me/db/functions/db_functions.dart';
import 'package:db_me/Widgets/student_details.dart';
import 'package:db_me/db/models/model.dart';
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
    return Scaffold(
        appBar: AppBar(
          title: const Text('Student List'),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
        body: SafeArea(
          child: FutureBuilder<List<StudentModel>>(
              future: FirebaseService().fetchStudents(),
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
                    itemCount: snapshot.data!.length,
                    itemBuilder: (ctx, index) {
                      final student = snapshot.data![index];
                      return ListTile(
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            student.name!,
                            style: const TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                        leading: const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: CircleAvatar(
                            // backgroundImage: FileImage(
                            //             File(data.image)
                            //           ),
                            radius: 50,
                          ),
                        ),
                        trailing: GestureDetector(
                          onTap: () {
                            _showDialog(ctx, index, student.id!);
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
                                student: student,
                                index: index,
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
              onPressed: () async{
                // deleteStudent(index);
                await delete(id);
                Navigator.of(context).pop();
                setState(() {
                  
                });
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
