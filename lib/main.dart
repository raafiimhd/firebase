import 'package:db_me/Widgets/screen_home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Hive.initFlutter();
  // if(!Hive.isAdapterRegistered(StudentModelAdapter().typeId)){
  //   Hive.registerAdapter(StudentModelAdapter());
  // }
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: const FirebaseOptions(
    apiKey: "AIzaSyC35vAaeNtl74Y9Yi04DKQwKL8F-CmtT-o",
      projectId: "studentrec-46da7",
      messagingSenderId: "65985740707",
      appId: "1:65985740707:web:9d0cd93a0efb18c3022416",
    ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.black,
      ),
      home: const ScreenHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}
