import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_list/screens/home_screen.dart';
import 'package:todo_list/services/firebase_services.dart';
import 'package:todo_list/utils/styles.dart';
import 'package:todo_list/widget/eco_button.dart';
import 'package:todo_list/widget/ecotextfild.dart';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  final CollectionReference _items =
      FirebaseFirestore.instance.collection('users');

  FocusNode? passwordfocus;
  final formkey = GlobalKey<FormState>();

  bool ispassword = true;
  bool formStateLoading = false;
  var newUrl;

  File? _image;
  final picker = ImagePicker();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future getImageGallery() async {
    final PickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

    setState(() {
      if (PickedFile != null) {
        _image = File(PickedFile.path);
      } else {
        print("no image Picked ");
      }
    });
  }

  Future<void> ecoDialogue(String error) async {
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

  Future<void> uploadImage() async {
    if (_image != null) {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref('/foldername/${FirebaseAuth.instance.currentUser!.uid}');
      firebase_storage.UploadTask uploadTask = ref.putFile(_image!.absolute);

      await uploadTask;
      newUrl = await ref.getDownloadURL();
    }
  }

  Future<void> submit() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        formStateLoading = true;
      });
      String? accountstatus = await FirebaseServices.createAccount(
        emailC.text,
        passwordC.text,
      );
      if (accountstatus != null) {
        ecoDialogue(accountstatus);
        setState(() {
          formStateLoading = false;
        });
      } else {
        await uploadImage();
        final String name = nameC.text;
        final String email = emailC.text;
        String userId = FirebaseAuth.instance.currentUser!.uid;
        if (email.isNotEmpty) {
          await _items.doc(userId).set({
            "name": name,
            "email": email,
            "userId": userId,
            "Image_URL": newUrl.toString()
          });
          nameC.text = '';
          emailC.text = '';
        }
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
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Welcome \n Please Create your Account",
                  textAlign: TextAlign.center,
                  style: EcoStyle.boldStyle,
                ),
                SizedBox(
                  height: 150,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Form(
                        key: formkey,
                        child: Column(
                          children: [
                            EcoTextField(
                              validate: (v) {
                                if (v!.isEmpty) {
                                  return "Name should not be empty";
                                }
                                return null;
                              },
                              inputAction: TextInputAction.next,
                              controller: nameC,
                              hintText: 'Name...',
                              icon: Icon(Icons.person),
                            ),
                            EcoTextField(
                              validate: (v) {
                                if (v!.isEmpty) {
                                  return "Email should not be empty";
                                }
                                return null;
                              },
                              inputAction: TextInputAction.next,
                              controller: emailC,
                              hintText: 'Email...',
                              icon: Icon(Icons.email),
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
                            Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    getImageGallery();
                                  },
                                  child: Container(
                                    height: 100,
                                    width: 100,
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.black)),
                                    child: _image != null
                                        ? Image.file(_image!.absolute)
                                        : Center(
                                            child: Icon(Icons.image),
                                          ),
                                  ),
                                )
                              ],
                            ),
                            EcoButton(
                              title: "SIGNUP",
                              isloginButton: true,
                              onPress: () async {
                                await submit();
                              },
                              isloding: formStateLoading,
                            ),
                          ],
                        )),
                  ],
                ),
                SizedBox(
                  height: 200,
                ),
                EcoButton(
                  title: "BACK TO LOGIN",
                  isloginButton: false,
                  onPress: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
