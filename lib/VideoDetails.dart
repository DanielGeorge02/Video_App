// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_typing_uninitialized_variables, must_be_immutable, file_names

import 'package:clicks/viewVideo.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VedioDetails extends StatefulWidget {
  VedioDetails(
      {super.key,
      required this.video,
      required this.name,
      required this.thumbnail,
      required this.description,
      required this.date,
      required this.lat,
      required this.long,
      required this.time});
  var name;
  var video;
  var time;
  var thumbnail;
  var description;
  var date;
  var lat;
  var long;
  @override
  State<VedioDetails> createState() => _VedioDetailsState();
}

class _VedioDetailsState extends State<VedioDetails> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
            )),
        elevation: 20,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        title: Text(
          widget.name,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        shadowColor: Colors.grey,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(height * 0.015),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Image.network(
                  widget.thumbnail,
                  fit: BoxFit.cover,
                  width: width,
                  height: height * 0.25,
                ),
                Center(
                  child: Container(
                    width: width * 0.11,
                    height: width * 0.11,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(width * 0.25),
                      color: const Color.fromARGB(88, 0, 0, 0),
                    ),
                    child: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ViewVedio(
                                      vedio: widget.video, name: widget.name)));
                        },
                        icon: const Icon(
                          Icons.play_arrow,
                          color: Color.fromARGB(134, 255, 255, 255),
                        )),
                  ),
                )
              ],
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.03),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Description:",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700, fontSize: 17),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.045, vertical: height * 0.01),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: width - width * 0.15,
                          child: Text(
                            widget.description,
                            style: GoogleFonts.poppins(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        width: width,
        height: height * 0.13,
        decoration: const BoxDecoration(
            color: Color(0xffF9504D),
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: width * 0.01),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    const Icon(Icons.location_on),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: height * 0.01, horizontal: width * 0.01),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Latitide: " + widget.lat,
                            style: GoogleFonts.poppins(fontSize: 12),
                          ),
                          Text(
                            "Longitude: " + widget.long,
                            style: GoogleFonts.poppins(fontSize: 12),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: width * 0.01),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    const Icon(Icons.date_range_outlined),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: height * 0.01, horizontal: width * 0.01),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Date: ${widget.date} ",
                            style: GoogleFonts.poppins(fontSize: 12),
                          ),
                          Text(
                            "Time: ${widget.time} ",
                            style: GoogleFonts.poppins(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
