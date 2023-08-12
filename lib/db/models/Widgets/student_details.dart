

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ScreenDetails extends StatelessWidget {
   ScreenDetails({
    super.key,
    required this.name,
    required this.age,
    required this.domain,
    required this.contact,
  
  });
  
  String name; 
  String age;
  String domain;
  String contact;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Details'),
      ),
      body: SafeArea(
        
        child: Container(
        child: Center(
          child: Column(children: [
            Text("Name:$name",
            style: TextStyle(fontSize: 20,
            ),
            ),
            Text('Age:$age',
            style: TextStyle(fontSize: 20),
            ),
            Text('Domain:$domain',
            style: TextStyle(fontSize: 20),
            ),
            Text('Conatct:$contact',
            style: TextStyle(fontSize: 20),
            ),
          
          ]), 
        ), 
      ),
      
      
      ),
    );
  }
}
