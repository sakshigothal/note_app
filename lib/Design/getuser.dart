// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class AddNotes extends StatefulWidget {
//   const AddNotes({Key? key}) : super(key: key);

//   @override
//   State<AddNotes> createState() => _AddNotesState();
// }

// class _AddNotesState extends State<AddNotes> {
//   TextEditingController subject = TextEditingController();
//   TextEditingController note = TextEditingController();
//   TextEditingController username = TextEditingController();
//   var noteList = [];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('Add Note'),
//         ),
//         body: StreamBuilder(
//             stream: FirebaseFirestore.instance.collection('Notes').snapshots(),
//             builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
//               return Container(
//                 child: Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     children: [
//                       // TextField(
//                       //     controller: username,
//                       //     decoration: InputDecoration(
//                       //       border: OutlineInputBorder(
//                       //           borderRadius: BorderRadius.circular(15)),
//                       //       labelText: 'Username',
//                       //     )),
//                       // SizedBox(height: 20),
//                       TextField(
//                           controller: subject,
//                           decoration: InputDecoration(
//                             border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(15)),
//                             labelText: 'Subject',
//                           )),
//                       SizedBox(height: 20),
//                       TextField(
//                           controller: note,
//                           decoration: InputDecoration(
//                             border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(15)),
//                             labelText: 'Note',
//                           )),
//                       SizedBox(height: 20),
//                       MaterialButton(
//                         onPressed: () {
//                           // setState(() {
//                           //   noteList.add({
//                           //     {'Subject': subject.text, 'Note': note.text}
//                           //   });
//                           // });
//                           // print(noteList.length);
//                           addMultipleNotes();
//                           addUserData();
//                           subject.clear();
//                           note.clear();
//                         },
//                         color: Colors.blue,
//                         height: 50,
//                         child: Center(
//                           child: Text(
//                             'Add',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               );
//             }));
//   }

//   addMultipleNotes() async {
//     FirebaseAuth auth = FirebaseAuth.instance;
//     print(auth.currentUser!.email.toString());

//     CollectionReference reference = FirebaseFirestore.instance
//         .collection('Notes')
//         .doc(auth.currentUser!.uid.toString())
//         .collection('notes');

//     var data = {'Subject': subject.text, 'Note': note.text};
//     reference.add(data);

//     // FirebaseFirestore.instance
//     //     .collection('Notes')
//     //     .doc(auth.currentUser!.uid.toString())
//     //     .set({
//     //   'user': auth.currentUser!.uid.toString(),
//     //   'notes': FieldValue.arrayUnion([
//     //     {'Subject': subject.text, 'Note': note.text}
//     //   ])
//     // });

//     // add({
//     //   'user': auth.currentUser!.uid.toString(),
//     //   'notes': {'Subject': subject.text, 'Note': note.text}
//     // });
//   }

//   addUserData() {
//     FirebaseAuth auth = FirebaseAuth.instance;
//     print(auth.currentUser!.email.toString());

//     FirebaseFirestore.instance
//         .collection('Notes')
//         .doc(auth.currentUser!.uid.toString())
//         .set({
//       'userID': auth.currentUser!.uid.toString(),
//       'userEmail': auth.currentUser!.email.toString()
//     });
//   }
// }
