
import 'package:db_me/db/functions/db_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../db/models/model.dart';
import 'screen_home.dart';

class Editpage extends StatefulWidget {
  Editpage({
    super.key,
    required this.student,
    required this.index,
  });

  // final StudentModel student;
  final StudentModel student;
  final int index;
  @override
  State<Editpage> createState() => _EditpageState();
}

class _EditpageState extends State<Editpage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;

  late TextEditingController ageController;

  late TextEditingController domainController;

  late TextEditingController numberController;


  @override
  @override
  void initState() {
    nameController = TextEditingController(text: widget.student.name);
    ageController = TextEditingController(text: widget.student.age);
    domainController = TextEditingController(text: widget.student.domain);
    numberController = TextEditingController(text: widget.student.contact);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Page'),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back_ios)),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: nameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                hintText: 'name',
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: ageController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your age';
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                hintText: 'age',
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: domainController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'please enter your domain';
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                hintText: 'domain',
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: numberController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter your number';
                } else if (value.length != 10) {
                  return 'Number must be 10';
                } else {
                  return null;
                }
              },
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                hintText: 'contact',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              onPressed: () async {
                // if (_formkey.currentState!.validate()) {
                await save(context);
                Navigator.pop(context);

                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ScreenHome(indexset: 2),
                    ));
                setState(() {});
                // },
              },
              icon: const Icon(Icons.save_alt_outlined),
              label: const Text('Save'),
            )
          ],
        ),
      ),
    );
  }

  Future<void> save(BuildContext ctx) async {
    ScaffoldMessenger.of(ctx).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
        content: Text('Saving'),
      ),
    );
    await Future.delayed(
      const Duration(seconds: 2),
    );

    final studentModel = StudentModel(
      name: nameController.text,
      age: ageController.text,
      domain: domainController.text,
      contact: numberController.text,
      // image: widget.student.image,
      id: widget.student.id,
    );
    await editStudent(studentModel, widget.index);
    if (!mounted) {
      return;
    }
    Navigator.of(context).pop();
  }

  void imagepicker() async {
    showDialog(
      context: context,
      builder: (ctx) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            width: 200,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    // getImage(ImageSource.camera);
                    Navigator.pop(ctx);
                  },
                  child: const Icon(Icons.camera_alt_sharp),
                ),
                GestureDetector(
                  onTap: () {
                    // getImage(ImageSource.gallery);
                    Navigator.pop(ctx);
                  },
                  child: const Icon(Icons.image_search),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // void getImage(ImageSource source) async {
  //   final image = await ImagePicker().pickImage(source: source);
  //   if (image == null) {
  //     return;
  //   } else {
  //     setState(() {
  //       // widget.student.image = imagepath.path;
  //     });
  //   }
  // }
}
