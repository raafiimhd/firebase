import 'package:flutter/material.dart';

class Editpage extends StatefulWidget {
  const Editpage({
    super.key,
    required this.name,
    required this.age,
    required this.domain,
    required this.contact
  });

  // final StudentModel student;
  final String name;
  final int age;
  final String domain;
  final int contact;

  @override
  State<Editpage> createState() => _EditpageState();
}

class _EditpageState extends State<Editpage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namecontroller = TextEditingController();
  final TextEditingController _agecontroller = TextEditingController();
  final TextEditingController _contactcontroller = TextEditingController();
  final TextEditingController _domaincontroler = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _namecontroller,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                } else {
                  return null;
                }
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'name',
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _agecontroller,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your age';
                } else {
                  return null;
                }
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'age',
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _domaincontroler,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please enter your domain';
                } else {
                  return null;
                }
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'domain',
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _contactcontroller,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter your number';
                } else if (value.length != 10) {
                  return 'Number must be 10';
                } else {
                  return null;
                }
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'contact',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              onPressed: () {
                // if (_formKey.currentState!.validate() && _cloudFile != null) {
                //   onAddStudentButton();
                //   submit();
                // } else {
                //   if (_cloudFile == null) {
                //     setState(() {
                //       isVisible = true;
                //     });
                //   } else {
                //     setState(() {
                //       isVisible = false;
                //     });
                //   }
                // }
              },
              child: const Text('Add Student'),
            )
          ],
        ),
      ),
    );
  }
}
