import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_app/Controller/controller.dart';
import 'package:note_app/Design/getuser.dart';
import 'package:note_app/Design/shownote.dart';
import 'package:note_app/Login/signin_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final controller = Get.put(NotesController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // checkUserIn();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text('Sign Up'),
          ),
          body: Obx(() {
            return Container(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      InkWell(
                          onTap: () {
                            controller.imagePicker();
                            // controller.getImage();
                          },
                          child: Container(
                            height: 150,
                            width: 150,
                            decoration: BoxDecoration(
                                color: Colors.pink,
                                borderRadius: BorderRadius.circular(150)),
                            child: controller.pickedImage.value != ''
                                ? ClipOval(
                                    child: Image.file(
                                    File(controller.pickedImage.value),
                                    fit: BoxFit.fill,
                                  ))
                                : SizedBox(),
                          )),
                      SizedBox(height: 20),
                      TextField(
                          controller: controller.firstName.value,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            labelText: 'Enter your First Name',
                          )),
                      SizedBox(height: 20),
                      TextField(
                          controller: controller.lastName.value,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            labelText: 'Enter your Last Name',
                          )),
                      SizedBox(height: 20),
                      TextField(
                          controller: controller.email.value,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            labelText: 'Enter your email',
                          )),
                      SizedBox(height: 20),
                      TextField(
                          controller: controller.password.value,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)),
                            labelText: 'Enter password',
                          )),
                      SizedBox(height: 20),
                      MaterialButton(
                        onPressed: () async {
                          showDialog(
                              context: context,
                              builder: (ctx) {
                                return Center(
                                    child: SpinKitFadingCircle(
                                  color: Colors.pink,
                                  size: 50.0,
                                ));
                              });

                          await controller.uploadImage();
                          await controller.register();
                          await controller.createUser();
                          Navigator.pop(context);
                          // await controller.uploadPic();
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'SignUp SuccessFully Done with ${FirebaseAuth.instance.currentUser!.email}'),
                            backgroundColor: Colors.green,
                          ));
                          controller.email.value.clear();
                          controller.password.value.clear();
                          controller.firstName.value.clear();
                          controller.lastName.value.clear();
                          // controller.createUser();
                        },
                        child: Center(
                            child: Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 17, color: Colors.white),
                        )),
                        height: 50,
                        color: Colors.pink,
                      ),
                      SizedBox(height: 20),
                      MaterialButton(
                        onPressed: () {
                          // controller.uploadPic();
                          Get.off(SignInPage());
                        },
                        child: Center(
                            child: Text(
                          'Sign In',
                          style: TextStyle(fontSize: 17, color: Colors.white),
                        )),
                        height: 50,
                        color: Colors.pink,
                      )
                    ],
                  ),
                ),
              ),
            );
          })),
    );
  }

  checkUserIn() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.get('user') != null) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (ctx) => ShowNotes()));
    }
  }
}
