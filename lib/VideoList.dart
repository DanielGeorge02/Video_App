// ignore_for_file: avoid_print, file_names, unnecessary_null_comparison

import 'package:clicks/Camera_Page.dart';
import 'package:clicks/PhoneNumberVerify.dart';
import 'package:clicks/Search.dart';
import 'package:clicks/VideoDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class VedioList extends StatefulWidget {
  const VedioList({super.key});

  @override
  State<VedioList> createState() => _VedioListState();
}

class _VedioListState extends State<VedioList> {
  CollectionReference users = FirebaseFirestore.instance
      .collection(FirebaseAuth.instance.currentUser!.phoneNumber.toString());

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: const Color(0xffF9504D),
        elevation: 20,
        shadowColor: Colors.grey,
        title: Text(
          "CLICKS",
          style: GoogleFonts.poppins(
              fontSize: 23, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25))),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Search()));
              },
              icon: Padding(
                padding: EdgeInsets.only(right: width * 0.015),
                child: const Icon(
                  Icons.search,
                  color: Colors.white,
                ),
              )),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text(
                    "Logout!",
                    style: GoogleFonts.poppins(),
                  ),
                  content: Text(
                    "Do you want to logout from the app?",
                    style: GoogleFonts.poppins(),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        child: Text(
                          "No",
                          style: GoogleFonts.poppins(),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const PhoneNumberVerfication()),
                            (route) => false);
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Color(0xffF9504D),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        padding: const EdgeInsets.all(14),
                        child: Text(
                          "Yes",
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            color: Colors.white,
            icon: const Icon(Icons.logout_outlined),
          )
        ],
        toolbarHeight: height * 0.1,
        backgroundColor: const Color(0xffF9504D),
      ),
      body: FutureBuilder(
        future: users.get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No videos Uplaoded"));
          } else {
            return Padding(
              padding: EdgeInsets.symmetric(
                  vertical: height * 0.015, horizontal: width * 0.03),
              child: GridView.builder(
                itemCount: snapshot.data!.docs.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: width * 0.04,
                    mainAxisSpacing: width * 0.05),
                itemBuilder: (BuildContext context, int index) {
                  DocumentSnapshot documentSnapshot =
                      snapshot.data!.docs[index];
                  return Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: () {
                        var dateFromTimeStramp =
                            DateTime.fromMillisecondsSinceEpoch(
                                documentSnapshot["date"].seconds * 1000);

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VedioDetails(
                                    video: documentSnapshot["URL"],
                                    name: documentSnapshot["Name"],
                                    thumbnail: documentSnapshot["thumbnail"],
                                    description:
                                        documentSnapshot["description"],
                                    date: DateFormat('dd-MM-yyyy hh:mm a')
                                        .format(dateFromTimeStramp)
                                        .toString()
                                        .substring(0, 10),
                                    time: DateFormat('dd-MM-yyyy hh:mm a')
                                        .format(dateFromTimeStramp)
                                        .toString()
                                        .substring(12, 19),
                                    lat: documentSnapshot["latitude"],
                                    long: documentSnapshot["longitude"])));
                        print(documentSnapshot["URL"]);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Stack(
                                    children: [
                                      SizedBox(
                                        child: Center(
                                          child: Image.network(
                                            documentSnapshot["thumbnail"],
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Container(
                                          width: width * 0.11,
                                          height: width * 0.11,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                width * 0.25),
                                            color: const Color.fromARGB(
                                                88, 0, 0, 0),
                                          ),
                                          child: IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                Icons.play_arrow,
                                                color: Color.fromARGB(
                                                    134, 255, 255, 255),
                                              )),
                                        ),
                                      )
                                    ],
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        users
                                            .doc(documentSnapshot
                                                .id) // <-- Doc ID to be deleted.
                                            .delete()
                                            .then((value) => print(
                                                documentSnapshot
                                                    .id)) // <-- Delete
                                            .then((_) => print('Deleted'))
                                            .catchError((error) =>
                                                print('Delete failed: $error'));
                                      },
                                      icon: const Icon(Icons.close))
                                ],
                              ),
                            ),
                            Container(
                              height: height * 0.05,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                  color: Color(0xffF9504D),
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10))),
                              child: Center(
                                  child: Text(
                                documentSnapshot['Name'],
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              )),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xffF9504D),
        onPressed: () {
          print(FirebaseAuth.instance.currentUser!.phoneNumber);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const CameraPage()));
        },
        child: const Icon(
          Icons.camera,
          color: Colors.white,
        ),
      ),
    );
  }
}
