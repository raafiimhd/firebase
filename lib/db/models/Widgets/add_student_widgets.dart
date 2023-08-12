import 'dart:io';
import 'package:db_me/db/models/db_models.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../db/functions/db_functions.dart';

class AddStudentWidget extends StatefulWidget {
  const AddStudentWidget({Key?key}) : super(key: key);

  @override
  State<AddStudentWidget> createState() => _AddStudentWidgetState();
}

class _AddStudentWidgetState extends State<AddStudentWidget> {
  final _formKey=GlobalKey<FormState>();
  bool isVisible=false;
  File?_image;

  final _nameController=TextEditingController();
  final _ageController=TextEditingController();
  final _domainController=TextEditingController();
  final _contactController=TextEditingController();
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student view'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment:  MainAxisAlignment.center,      
                  children: [
                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      child: GestureDetector(
                        onTap: (){
                          imagepicker();
                        },
                        child: Stack(
                          children: [
                            _image==null?
                            const CircleAvatar(
                             backgroundColor: Colors.grey,
                            )
                            :CircleAvatar(
                              backgroundImage: FileImage(
                                File(_image!.path)
                              ),
                              radius: 50,
                            ),
                          const Padding(padding: EdgeInsets.only(
                            left: 46,
                            right: 10,
                          ))
                          ]
                        ),
                      ),
                    ),
                    const SizedBox(
                    height: 10,
                  ),
                  Visibility(
                    visible: isVisible,
                    child: const Text(
                      'Please Add Photo',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                    TextFormField(
                     
                      controller: _nameController,
                      validator: (value) {
                        if(value==null||value.isEmpty){
                          return 'Please enter your name';
                        }else{
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
                      controller: _ageController,
                      validator: (value) {
                        if(value==null||value.isEmpty){
                          return 'Please enter your age';
                        }else{
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
                      controller: _domainController,
                      validator: (value){
                        if(value==null||value.isEmpty){
                          return 'please enter your domain';
                        }else{
                          return null;
                        }
                      },
                      decoration:const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'domain',
                      ),
                    ),
                   const SizedBox(height: 10),
                    TextFormField(
                      controller: _contactController,
                      validator: (value) {
                        if(value==null||value.isEmpty){
                          return 'Please Enter your number';
                        }else if(value.length!=10){
                          return 'Number must be 10';
                        }else{
                          return null;
                        }
                      },
                      decoration:const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'contact',
                      ),
                    ),
                  const  SizedBox(height: 10),
                   ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate() && _image != null) {
                        onAddStudentButton();
                        submit(); 
                      } else {
                        if (_image == null) {
                          setState(() {
                            isVisible = true;
                          });
                        } else {
                          setState(() {
                            isVisible = false;
                          });
                        }
                      }
                    },
                    child: const Text('Add Student'),
                  )
                  ],
                ),
              ),
            ),
          
        ),
      ),
    );
  }
  
  void imagepicker() async {
    showDialog(
      context: context,
      builder: (ctx) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.white,
            ),
            width: 200,
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    getImage(ImageSource.camera);
                    Navigator.pop(ctx);
                  },
                  child:const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:  [
                      Icon(Icons.camera_alt_sharp),
                      Text(
                        'Camera',
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 10,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    getImage(ImageSource.gallery);
                    Navigator.pop(ctx);
                  },
                  child:const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:  [
                      Icon(Icons.image_search),
                      Text(
                        'Gallery',
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          fontSize: 10,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

    void getImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(source: source);
    if (image == null) {
      return;
    } else {
      final imagepath = File(image.path);
      setState(() {
        _image = imagepath;
      });
    }
  }
  void submit() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
        content: Text('Adding Data...'),
      ),
    );
    await Future.delayed(
      const Duration(seconds: 2),
    );
  }
 

  
  Future<void> onAddStudentButton() async{
    final name=_nameController.text.trim();
    final age=_ageController.text.trim();
    final domain=_domainController.text.trim();
    final contact=_contactController.text.trim();
   await addStudent(StudentModel(name: name,
    age:int.parse(age) ,
     domain: domain,
      contact: int .parse(contact),
      image: _image!.path) );
     
  //  await Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => ListStudentWidget(),
  //       )
  //  );
    }
  }

 

  

