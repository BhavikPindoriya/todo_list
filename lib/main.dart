import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:sizer/sizer.dart';
import 'package:todo_list/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyDRYQeOU2iHDp4sQ09vZ4EGdmuXQnZOG4o",
          appId: "1:980779477461:web:7b0df65ec3db026eceb55c",
          messagingSenderId: "980779477461",
          projectId: "todolist-438b6",
          storageBucket: 'todolist-438b6.appspot.com'));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (BuildContext context, Orientation orientation,
              DeviceType deviceType) =>
          GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ToDoList',
        theme: ThemeData(
            primarySwatch: Colors.blue, backgroundColor: Colors.white),
        home: const Splase_screen(),
      ),
    );
  }
}
