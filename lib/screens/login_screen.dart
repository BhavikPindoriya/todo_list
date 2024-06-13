import 'package:flutter/material.dart';
import 'package:todo_list/screens/home_screen.dart';
import 'package:todo_list/screens/sign_up_screen.dart';
import 'package:todo_list/services/firebase_services.dart';
import 'package:todo_list/utils/styles.dart';
import 'package:todo_list/widget/eco_button.dart';
import 'package:todo_list/widget/ecotextfild.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formkey = GlobalKey<FormState>();
  bool formStateLoading = false;
  bool ispassword = true;
  FocusNode? passwordfocus;
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();

  Future<void> ecoDilogue(String error) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(error),
          actions: [
            EcoButton(
              title: 'Close',
              onPress: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  submit() async {
    print(formkey.currentState!.validate());
    if (formkey.currentState!.validate()) {
      setState(() {
        formStateLoading = true;
      });
      String? accountstatus =
          await FirebaseServices.signInAccount(emailC.text, passwordC.text);
      if (accountstatus != null) {
        ecoDilogue(accountstatus);
        setState(() {
          formStateLoading = false;
        });
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Welcome \n Please login first",
                textAlign: TextAlign.center,
                style: EcoStyle.boldStyle,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Form(
                      key: formkey,
                      child: Column(
                        children: [
                          EcoTextField(
                            controller: emailC,
                            hintText: 'Email...',
                            validate: (v) {
                              if (v!.isEmpty ||
                                  !v.contains("@") ||
                                  !v.contains(".com")) {
                                return "email is badly formated";
                              }
                              return null;
                            },
                          ),
                          EcoTextField(
                            focusNode: passwordfocus,
                            validate: (v) {
                              if (v!.isEmpty) {
                                return "Password should not be empty";
                              }
                              return null;
                            },
                            isPassword: ispassword,
                            controller: passwordC,
                            hintText: 'Password...',
                            icon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    ispassword = !ispassword;
                                  });
                                },
                                icon: ispassword
                                    ? Icon(Icons.visibility_off)
                                    : Icon(Icons.visibility)),
                          ),
                          EcoButton(
                            onPress: () {
                              submit();
                            },
                            isloding: formStateLoading,
                            title: "Login",
                            isloginButton: true,
                          ),
                        ],
                      )),
                ],
              ),
              EcoButton(
                title: "Create New Account",
                isloginButton: false,
                onPress: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUpScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ));
  }
}
