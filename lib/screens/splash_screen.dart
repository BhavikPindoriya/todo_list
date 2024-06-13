import 'package:flutter/material.dart';
import 'package:todo_list/screens/landing_screen.dart';

class Splase_screen extends StatefulWidget {
  const Splase_screen({super.key});

  @override
  State<Splase_screen> createState() => _Splase_screenState();
}

class _Splase_screenState extends State<Splase_screen> {
  changeScreen() {
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LandingScreen(),
          ));
    });
  }

  @override
  void initState() {
    changeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Text(
        "Welcome ToDoList",
        style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
      )),
    );
  }
}
