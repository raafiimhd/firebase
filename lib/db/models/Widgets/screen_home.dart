
import 'package:db_me/db/functions/db_functions.dart';
import 'package:db_me/db/models/Widgets/add_student_widgets.dart';
import 'package:db_me/db/models/Widgets/list_student_widgets.dart';
import 'package:db_me/db/models/Widgets/search_db.dart';
import 'package:flutter/material.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  int index=0;
  final pages=[
     AddStudentWidget(),
      SearchWidget(),
     ListStudentWidget()
  ];
  @override
  Widget build(BuildContext context) {
    getAllStudents();
    return Scaffold(
      body: pages[index],
        //  appBar: AppBar(
        //       title: Text('Student View',
        //       ),
        //       centerTitle: true,
        //   ),
        
          
          // AddStudentWidget(),
          // Expanded(child: ListStudentSidget()),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: index,
          backgroundColor: Colors.lime,
           selectedItemColor: Colors.blue,
           showSelectedLabels: true,
           onTap: (value){
            setState(() {
              index=value;
            }
            );
           },
          

          items:const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add',
          ),
            BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            label: 'Search',
          ),
            BottomNavigationBarItem(
            icon: Icon(Icons.list_outlined),
            label: 'List',
          ),
        ]),
      );
  }
}