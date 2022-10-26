import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:note_app/Controller/controller.dart';
import 'package:note_app/Design/getuser.dart';
import 'package:note_app/Design/shownote.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  // TextEditingController email = TextEditingController();
  // TextEditingController password = TextEditingController();
  final controller = Get.put(NotesController());
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text('Sign In'),
          ),
          body: Obx(() {
            return Container(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(children: [
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
                       MaterialButton(onPressed: ()async{
                     SharedPreferences pref =
                            await SharedPreferences.getInstance();
                        FirebaseAuth auth = FirebaseAuth.instance;
                         showDialog(
                              context: context,
                              builder: (ctx) {
                                return Center(
                                    child: SpinKitFadingCircle(
                                  color: Colors.pink,
                                  size: 50.0,
                                ));
                              });
                        await auth.signInWithEmailAndPassword(
                          email: controller.email.value.text,
                          password: controller.password.value.text,
                        );
                        pref.setString(
                            'user', auth.currentUser!.uid.toString());
                        
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'SignIn SuccessFully Done With ${FirebaseAuth.instance.currentUser!.email}'),
                          backgroundColor: Colors.green,
                        ));
                        // controller.createUser();
                        print(pref.getString('user'));
                        Get.off(ShowNotes());
                    },child: Center(child: Text('Sign In',style: TextStyle(fontSize: 17,color: Colors.white),)),height: 50,color: Colors.pink,)
                ]),
              ),
            );
          })),
    );
  }
}
