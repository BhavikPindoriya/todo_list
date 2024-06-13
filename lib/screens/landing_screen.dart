import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/screens/home_screen.dart';
import 'package:todo_list/screens/login_screen.dart';
import 'package:todo_list/utils/styles.dart';

class LandingScreen extends StatelessWidget {
  Future<FirebaseApp> initilize = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initilize,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("${snapshot.error}"),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, streamsnapshot) {
              if (streamsnapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("${streamsnapshot.error}"),
                  ),
                );
              }

              if (streamsnapshot.connectionState == ConnectionState.active) {
                User? user = streamsnapshot.data;

                print("This is the user:- $user");
                if (user == null) {
                  return const LoginScreen();
                } else {
                  return HomeScreen();
                }
              }

              return const Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Checking Authentication",
                        textAlign: TextAlign.center,
                        style: EcoStyle.boldStyle,
                      ),
                      CircularProgressIndicator()
                    ],
                  ),
                ),
              );
            },
          );
        }

        return const Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Initiallization",
                  style: EcoStyle.boldStyle,
                ),
                CircularProgressIndicator()
              ],
            ),
          ),
        );
      },
    );
  }
}

Future<int> Futurebuilder() async {
  await Future.delayed(const Duration(seconds: 3));
  return 0;
}
