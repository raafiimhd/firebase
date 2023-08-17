import 'package:db_me/Widgets/editpage.dart';
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
  int age;
  String domain;
  int contact;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Details'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (ctx) => Editpage(
                      name:name ,
                      age: age,
                      domain: domain,
                      contact: contact, 
                    )));
              },
              icon: Icon(Icons.edit))
        ],
      ),
      body: SafeArea(
        child: Container(
          child: Center(
            child: Column(children: [
              Text(
                "Name:$name",
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              Text(
                'Age:$age',
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                'Domain:$domain',
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                'Conatct:$contact',
                style: const TextStyle(fontSize: 20),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
