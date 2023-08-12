
import 'package:db_me/db/functions/db_functions.dart';
import 'package:db_me/db/models/Widgets/student_details.dart';
import 'package:db_me/db/models/db_models.dart';
import 'package:flutter/material.dart';
class ListStudentWidget extends StatelessWidget {
  ListStudentWidget({Key? key});
  
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: studentListNotifier,
      builder: (BuildContext ctx, List<StudentModel> studentList, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Student List'),
          ),
          body: SafeArea(
            child: ListView.builder(
              itemBuilder: (ctx, index) {
                final data = studentList[index];
                return ListTile(
                  title: Text(data.name),
                  leading: CircleAvatar(
                    radius: 59,
                  ),
                  trailing: GestureDetector(
                    onTap: () {
                      _showDialog(ctx, index); 
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
                          name: data.name,
                          age: data.age.toString(),
                          domain: data.domain,
                          contact: data.contact.toString(),
                        ),
                      ),
                    );
                  },
                );
              },
              itemCount: studentList.length,
            ),
          ),
        );
      },
    );
  }
  

  Future<void> _showDialog(BuildContext context, int index) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are you sure you want to delete this student?'),
          actions: [
            TextButton(
              onPressed: () {
                deleteStudent(index);
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }
  
}



