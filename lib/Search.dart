// ignore_for_file: unrelated_type_equality_checks, file_names, avoid_print

import 'package:clicks/VideoDetails.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchController = TextEditingController();
  String search = "";
  @override
  void initState() {
    super.initState();
    search = "";
  }

  @override
  void dispose() {
    super.dispose();
    search = "";
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: height * 0.12,
          elevation: 20,
          shadowColor: Colors.grey,
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.black,
              )),
          title: Padding(
            padding: EdgeInsets.only(top: height * 0.015),
            child: SizedBox(
              height: height * 0.06,
              child: TextFormField(
                controller: searchController,
                onChanged: (value) {
                  setState(() {
                    search = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: "Search Video",
                  labelStyle: const TextStyle(color: Colors.black),
                  fillColor: Colors.white,
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: const BorderSide(
                      color: Color(0xffF9504D),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      width: 3,
                      color: Color(0xffF9504D),
                    ), //<-- SEE HERE
                  ),
                ),
              ),
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(
                  FirebaseAuth.instance.currentUser!.phoneNumber.toString())
              .snapshots(),
          builder: (context, snapshot) {
            return (snapshot.connectionState == ConnectionState.waiting)
                ? const Center(
                    child: CircularProgressIndicator(
                    color: Color(0xffF9504D),
                  ))
                : Padding(
                    padding: EdgeInsets.all(height * 0.01),
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var data = snapshot.data!.docs[index].data()
                            as Map<String, dynamic>;
                        var dateFromTimeStramp =
                            DateTime.fromMillisecondsSinceEpoch(
                                data["date"].seconds * 1000);

                        try {
                          if (data.isEmpty) {
                            return const Center(child: Text("No data found!"));
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (data["Name"]
                              .toString()
                              .toLowerCase()
                              .startsWith(search.toString().toLowerCase())) {
                            return InkWell(
                              // splashColor: Color(0xffF9504D),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => VedioDetails(
                                              date: dateFromTimeStramp
                                                  .toString()
                                                  .substring(0, 10),
                                              description: data["description"],
                                              lat: data["latitude"],
                                              long: data["longitude"],
                                              name: data["Name"],
                                              thumbnail: data["thumbnail"],
                                              time: dateFromTimeStramp
                                                  .toString()
                                                  .substring(11, 19),
                                              video: data["URL"],
                                            )));
                              },
                              child: Padding(
                                padding: EdgeInsets.only(top: height * 0.01),
                                child: ListTile(
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  title: Text(
                                    data["Name"],
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13),
                                  ),
                                  tileColor:
                                      const Color.fromARGB(255, 244, 174, 173),
                                  trailing: Text(
                                    DateFormat('dd-MM-yyyy hh:mm a')
                                        .format(dateFromTimeStramp)
                                        .toString()
                                        .substring(0, 10),
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 13),
                                  ),
                                ),
                              ),
                            );
                          }
                        } catch (e) {
                          print(e);
                        }
                        return Container();
                      },
                    ),
                  );
          },
        ));
  }
}
