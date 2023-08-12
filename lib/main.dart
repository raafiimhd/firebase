
import 'package:db_me/db/models/Widgets/screen_home.dart';
import 'package:db_me/db/models/db_models.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';


Future<void> main () async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if(!Hive.isAdapterRegistered(StudentModelAdapter().typeId)){
    Hive.registerAdapter(StudentModelAdapter());
  }
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
    home: ScreenHome(),
    debugShowCheckedModeBanner: false,
    );
  }
}

