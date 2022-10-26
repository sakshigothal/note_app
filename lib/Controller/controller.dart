import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_app/Design/shownote.dart';
import 'package:note_app/Login/signup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesController extends GetxController {
  Rx<TextEditingController> email = TextEditingController().obs;
  Rx<TextEditingController> password = TextEditingController().obs;
  var success = false.obs;
  var userEmail = ''.obs;

  Rx<TextEditingController> firstName = TextEditingController().obs;
  Rx<TextEditingController> lastName = TextEditingController().obs;

  Rx<Random> random = Random().obs;

  Future<QuerySnapshot<Map<String, dynamic>>> querySnapshot =
      FirebaseFirestore.instance.collection('user').where('name').get();

  var colorsList = [
    Colors.green.withOpacity(0.5),
    Colors.amber.withOpacity(0.5),
    Colors.blue.withOpacity(0.5),
    Colors.cyan.withOpacity(0.5),
    Colors.deepOrangeAccent.withOpacity(0.5),
    Colors.grey.withOpacity(0.5),
    Colors.pink.withOpacity(0.5),
    Colors.redAccent.withOpacity(0.5),
    Colors.indigo.withOpacity(0.5),
    Colors.yellow.withOpacity(0.5),
    Colors.teal.withOpacity(0.5),
    Colors.lime.withOpacity(0.5),
    Colors.blueAccent.withOpacity(0.5)
  ];
  Rx<TextEditingController> subject = TextEditingController().obs;
  Rx<TextEditingController> note = TextEditingController().obs;

  CollectionReference<Map<String, dynamic>> reference = FirebaseFirestore
      .instance
      .collection('Notes')
      .doc(FirebaseAuth.instance.currentUser?.uid.toString())
      .collection('notes');
  FirebaseAuth auth = FirebaseAuth.instance;

  addUserData() {
    print(auth.currentUser!.email.toString());

    FirebaseFirestore.instance
        .collection('Notes')
        .doc(auth.currentUser?.uid.toString())
        .set({
      'userID': auth.currentUser?.uid.toString(),
      'userEmail': auth.currentUser?.email.toString(),
      'FirstName': firstName.value.text,
      'LastName': lastName.value.text,
      'ImagePath': uploadPath
    });
  }

  addMultipleNotes() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    print(auth.currentUser!.email.toString());

    CollectionReference reference = FirebaseFirestore.instance
        .collection('Notes')
        .doc(auth.currentUser?.uid.toString())
        .collection('notes');

    var data = {'Subject': subject.value.text, 'Note': note.value.text};
    reference.add(data);
    // FirebaseFirestore.instance
    //     .collection('Notes')
    //     .doc(auth.currentUser!.uid.toString())
    //     .set({
    //   'user': auth.currentUser!.uid.toString(),
    //   'notes': FieldValue.arrayUnion([
    //     {'Subject': subject.text, 'Note': note.text}
    //   ])
    // });

    // add({
    //   'user': auth.currentUser!.uid.toString(),
    //   'notes': {'Subject': subject.text, 'Note': note.text}
    // });
  }

  createUser() async {
    // uploadPic();
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser?.uid.toString())
        .set({
      'username': email.value.text,
      'user': auth.currentUser!.uid.toString(),
      'FirstName': firstName.value.text,
      'LastName': lastName.value.text,
      'ImagePath': uploadPath
    });

    Snapshot = await FirebaseFirestore.instance
        .collection('Notes')
        .where(auth.currentUser!.uid.toString())
        .get();
    // .add({'username': email.text,'user':auth.currentUser!.uid.toString()});
  }

  register() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      final user = (await auth.createUserWithEmailAndPassword(
        email: email.value.text,
        password: password.value.text,
      ))
          .user;
      if (user != null) {
        success.value = true;
        userEmail.value = user.email!;
      } else {
        success.value = true;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  checkUserIn() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.get('user') != null) {
      Get.to(ShowNotes());
      // Navigator.push(context, MaterialPageRoute(builder: (ctx) => ShowNotes()));
    } else {
      Get.to(SignUpPage());
    }
  }

  // Rx<File>? file;
  // final imagepicker = ImagePicker();
  // String baseURL = '';

  // Future getImage() async {
  //   var image = await imagepicker.pickImage(source: ImageSource.gallery);
  //   if (image != null) {
  //     file = File(image.name).obs;
  //     update();
  //   } else {
  //     print('not picked');
  //   }

  //   print(image?.path);
  // }

  // Future uploadPic() async {
  //   DocumentReference sightingRef = FirebaseFirestore.instance.collection('bhdncbjd').doc();
  //   // baseURL = 'Users Image/${file!.value}';
  //   // final storageRef = FirebaseStorage.instance.ref();
  //   // final mountainImagesRef = storageRef.child("Users Image/$file.");
  //   // await mountainImagesRef.putFile(file!.value);
  //   // print(mountainImagesRef.fullPath);
  //   // print(baseURL);

  //   // Reference reference = FirebaseStorage.instance.ref().child('Users Image/$file');
  //   // UploadTask uploadTask = reference.putFile(file!);

  //   // var a = await reference.putFile(file!.value);
  //   // print(reference.fullPath);
  //   // print(a.toString());
  // }

  File? _photo;
  final ImagePicker _picker = ImagePicker();

  QuerySnapshot? Snapshot;

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _photo = File(pickedFile.path);
      // uploadFile();
    } else {
      print('No image selected.');
    }
  }

  String imageName = '';
  var pickedImage = ''.obs;
  XFile? imagePath;
  final ImagePicker picker = ImagePicker();
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  String collectionName = 'Notes';
  var uploadPath;

  imagePicker() async {
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      imagePath = image;
      imageName = image.name.toString();
      pickedImage.value = image.path;
      update();
    }
  }

  uploadImage() async {
    var uniqueKey = firebaseFirestore.collection(collectionName);
    String uploadFileName = DateTime.now().toString() + '.jpg';
    Reference reference =
        storage.ref().child(collectionName).child(uploadFileName);
    UploadTask uploadTask = reference.putFile(File(imagePath!.path));
    uploadTask.snapshotEvents.listen((event) {
      print(event.bytesTransferred);
    });

    await uploadTask.whenComplete(() async {
      uploadPath = await uploadTask.snapshot.ref.getDownloadURL();

      // if (uploadPath.isNotEmpty) {
      //   firebaseFirestore.collection('Notes').doc(auth.currentUser!.uid).set(
      //       {'Image': uploadPath}).then((value) => print('record inserted'));
      // } else {
      //   print('record not inserted');
      // }
    });
  }

  var fname = ''.obs;
  var profile = ''.obs;
  var lname = ''.obs;
  var currentUser = ''.obs;
  getData() async {
    // QuerySnapshot snapshot =
    //     await FirebaseFirestore.instance.collection('Users').get();
    // .doc(controller.auth.currentUser.toString())
    // .collection('FirstName').
    // .get();

    // print('reference------>' + snapshot.docs[3]['username']);

    var document = FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser!.uid.toString());
    document.get().then((document) {
      print(document['FirstName']);
      fname.value = document['FirstName'];
      lname.value = document['LastName'];
      profile.value = document['ImagePath'];
      currentUser.value = document['username'];
      update();
      print(fname);
      print(lname);
      print(profile);
      print(currentUser);
    });
  }
}
