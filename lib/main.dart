import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:note_app/Controller/controller.dart';
import 'package:note_app/Design/shownote.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Design/getuser.dart';
import 'Login/signup_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var loggedIn = prefs.getString('user') == null ? false : true;
  runApp(GetMaterialApp(
      title: 'Flutter demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: loggedIn ? ShowNotes() : SignUpPage(),
    ));
  
}

final controller = Get.put(NotesController());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Future.delayed(Duration(milliseconds: 0), () {
    //   controller.checkUserIn();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter demo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      // home: loggedIn ? SignUpPage() ?,
    );
  }
}

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);

//   // This widget is the root of your application.

  
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.pink,
//       ),
//       home: SignUpPage(),
//     );
//   }
// }
