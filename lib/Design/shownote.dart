import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:note_app/Controller/controller.dart';
import 'package:note_app/Login/signup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowNotes extends StatefulWidget {
  const ShowNotes({Key? key}) : super(key: key);

  @override
  State<ShowNotes> createState() => _ShowNotesState();
}

class _ShowNotesState extends State<ShowNotes> {
  final controller = Get.put(NotesController());
  CollectionReference reference = FirebaseFirestore.instance
      .collection('Notes')
      .doc(FirebaseAuth.instance.currentUser!.uid.toString())
      .collection('notes');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.getData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          drawer: Drawer(
            child: Padding(
                padding: const EdgeInsets.only(top: 30, left: 5, right: 5),
                child: Obx(() {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(controller.profile.value),
                                  fit: BoxFit.cover),
                              // color: Colors.pink,
                              borderRadius: BorderRadius.circular(100))),
                      SizedBox(height: 10),
                      Text(controller.fname.value,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Text('First Name  ',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(controller.fname.value,
                                style: TextStyle(
                                  fontSize: 15,
                                ))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Text('Last Name   ',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(controller.lname.value,
                                style: TextStyle(
                                  fontSize: 15,
                                ))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Text('Email    ',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(controller.currentUser.value,
                                style: TextStyle(
                                  fontSize: 15,
                                ))
                          ],
                        ),
                      ),
                    ],
                  );
                })),
          ),
          appBar: AppBar(
            actions: [
              IconButton(
                  onPressed: () async {
                    logoutAlert();
                  },
                  icon: Icon(Icons.logout))
            ],
            title: Text('Notes'),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              addNotesDialog();
              // Navigator.push(
              //     context, MaterialPageRoute(builder: (ctx) => AddNotes()));
            },
            child: Center(
              child: Icon(Icons.note_alt_outlined),
            ),
          ),
          body: SingleChildScrollView(
            child: StreamBuilder(
                stream: reference.snapshots(),
                // FirebaseFirestore.instance.collection('Notes').snapshots(),
                builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    // return Obx(() {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: StaggeredGrid.count(
                        crossAxisCount: 2,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                        children:
                            List.generate(snapshot.data!.docs.length, (index) {
                          Color bg = controller
                              .colorsList[controller.random.value.nextInt(13)];
                          Map data = snapshot.data?.docs[index].data() as Map;
                          return InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (ctx) {
                                    controller.subject.value.text =
                                        data['Subject'];
                                    controller.note.value.text = data['Note'];
                                    return AlertDialog(
                                      contentPadding: EdgeInsets.all(0),
                                      content: Container(
                                        color: bg,
                                        height: 400,
                                        width: 550,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              TextField(
                                                  controller:
                                                      controller.subject.value,
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15)),
                                                    labelText: 'Subject',
                                                  )),
                                              SizedBox(height: 20),
                                              TextField(
                                                  controller:
                                                      controller.note.value,
                                                  decoration: InputDecoration(
                                                    border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15)),
                                                    labelText: 'Note',
                                                  )),
                                              SizedBox(height: 20),
                                              MaterialButton(
                                                onPressed: () {
                                                  // setState(() {
                                                  snapshot.data!.docs[index]
                                                      .reference
                                                      .update({
                                                    'Subject': controller
                                                        .subject.value.text,
                                                    'Note': controller
                                                        .note.value.text
                                                    // });
                                                  });
                                                  Navigator.pop(context, true);

                                                  controller.subject.value
                                                      .clear();
                                                  controller.note.value.clear();
                                                },
                                                color: Colors.blue,
                                                height: 50,
                                                child: Center(
                                                  child: Text(
                                                    'Update',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              MaterialButton(
                                                onPressed: () {
                                                  // setState(() {
                                                  snapshot.data!.docs[index]
                                                      .reference
                                                      .delete();
                                                  // });
                                                  Navigator.pop(context, true);

                                                  controller.subject.value
                                                      .clear();
                                                  controller.note.value.clear();
                                                },
                                                color: Colors.blue,
                                                height: 50,
                                                child: Center(
                                                  child: Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  });
                            },
                            child: Container(
                              color: bg,
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(data['Subject'],
                                        style: TextStyle(
                                            fontSize: 21,
                                            fontWeight: FontWeight.bold)),
                                    Text(data['Note'],
                                        style: TextStyle(fontSize: 18)),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    );
                    // });
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
          )),
    );
  }

  addNotesDialog() {
    showDialog(
        context: context,
        builder: (ctx) {
          // return Obx(() {
          return StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('Notes').snapshots(),
              builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
                return Obx(() {
                  return AlertDialog(
                    contentPadding: EdgeInsets.all(0),
                    content: Container(
                      height: 300,
                      width: 550,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            TextField(
                                controller: controller.subject.value,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  labelText: 'Subject',
                                )),
                            SizedBox(height: 20),
                            TextField(
                                controller: controller.note.value,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  labelText: 'Note',
                                )),
                            SizedBox(height: 20),
                            MaterialButton(
                              onPressed: () {
                                controller.addMultipleNotes();
                                controller.addUserData();
                                controller.subject.value.clear();
                                controller.note.value.clear();
                                Navigator.pop(context);
                              },
                              color: Colors.pink,
                              height: 50,
                              child: Center(
                                child: Text(
                                  'Add',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                });
              });
          // });
        });
  }

  logoutAlert() {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            contentPadding: EdgeInsets.only(left: 10, right: 10),
            content: Container(
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Are you sure you want to Logout?',
                    style: TextStyle(fontSize: 18),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(onPressed: () async{
                        SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    FirebaseAuth auth = FirebaseAuth.instance;
                    await auth.signOut();
                    pref.clear();
                    Get.off(SignUpPage());
                    controller.email.value.clear();
                    controller.password.value.clear();
                    controller.onClose();
                      }, child: Text('Yes')),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('No'))
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
