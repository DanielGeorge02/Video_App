// ignore_for_file: non_constant_identifier_names, library_private_types_in_public_api, invalid_return_type_for_catch_error, file_names, avoid_print, use_build_context_synchronously, prefer_typing_uninitialized_variables

import 'dart:async';

import 'dart:io';
import 'dart:typed_data';

import 'package:clicks/dialogController.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_snackbar/fancy_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera/flutter_camera.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:video_thumbnail/video_thumbnail.dart';

class CameraPage extends ConsumerStatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends ConsumerState<CameraPage> {
  TextEditingController Name_controller = TextEditingController();
  TextEditingController desc_controller = TextEditingController();

  var lat;
  var long;
  showLoader(BuildContext context) {
    AlertDialog alert = const AlertDialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        content: Center(
          child: CircularProgressIndicator(),
        ));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Future<String> uploadFile(File file, name) async {
      FirebaseStorage fs = FirebaseStorage.instance;
      var snapshot = await fs.ref().child("docs").child(name).putFile(file);
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    }

    Future<Uint8List> generateThumbnail(String videoPath) async {
      try {
        final thumbnail = await VideoThumbnail.thumbnailData(
          video: videoPath,
          imageFormat: ImageFormat.JPEG,
          quality: 50,
        );
        return Uint8List.fromList(thumbnail!);
      } catch (e) {
        print('Error generating thumbnail: $e');
        return Uint8List(0);
      }
    }

    @override
    Future addUser(File file, String format, String name) async {
      String url = await uploadFile(file, name);
      Uint8List? thumbnailBytes = await generateThumbnail(url);

      Reference thumbnailReference =
          FirebaseStorage.instance.ref().child('thumbnails/$url/thumbnail.jpg');
      await thumbnailReference.putData(thumbnailBytes);

      String thumbnailDownloadUrl = await thumbnailReference.getDownloadURL();

      final users = FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser!.phoneNumber.toString())
          .doc();

      return await users
          .set({
            'thumbnail': thumbnailDownloadUrl.toString(),
            'date': DateTime.now(),
            'Name': Name_controller.text,
            'URL': url,
            "description": desc_controller.text,
            "Format":
                format.toString().substring(format.length - 4, format.length),
            "Id": users.id,
            "latitude": lat.toString(),
            "longitude": long.toString()
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add video: $error"));
    }

    return FlutterCamera(
        color: const Color(0xffF9504D),
        iconColor: Colors.white,
        onVideoRecorded: (value) {
          final height = MediaQuery.of(context).size.height;
          String format = value.path;
          File file = File(value.path);
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    "About Video",
                    style: GoogleFonts.poppins(),
                  ),
                  content: ref.read(dialogController) == 1
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xffF9504D),
                          ),
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextFormField(
                              controller: Name_controller,
                              textAlign: TextAlign.center,
                              autofocus: true,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  hintText: "Name",
                                  contentPadding: EdgeInsets.zero,
                                  filled: true,
                                  fillColor: Colors.white),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: height * 0.01),
                              child: TextFormField(
                                controller: desc_controller,
                                textAlign: TextAlign.center,
                                autofocus: true,
                                minLines: 1,
                                maxLines: 10,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    hintText: "Description",
                                    contentPadding: EdgeInsets.zero,
                                    filled: true,
                                    fillColor: Colors.white),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: height * 0.01),
                              child: TextFormField(
                                enableInteractiveSelection: false,
                                textAlign: TextAlign.center,
                                enabled: false,
                                decoration: InputDecoration(
                                    border: const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(15))),
                                    hintText: format.toString().substring(
                                        format.length - 4, format.length),
                                    contentPadding: EdgeInsets.zero,
                                    filled: true,
                                    fillColor: const Color.fromARGB(
                                        98, 255, 255, 255)),
                              ),
                            ),
                          ],
                        ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.poppins(color: Colors.black),
                      ),
                    ),
                    TextButton(
                        onPressed: () async {
                          var status = await Permission.location.request();
                          if (status.isGranted) {
                            Position position =
                                await Geolocator.getCurrentPosition(
                              desiredAccuracy: LocationAccuracy.high,
                            );

                            lat = position.latitude.toString();
                            long = position.longitude.toString();

                            showLoader(context);
                            addUser(file, format, Name_controller.text)
                                .then((value) => FancySnackbar.showSnackbar(
                                      context,
                                      snackBarType: FancySnackBarType.success,
                                      color: SnackBarColors.success5,
                                      title: "Successfully Saved",
                                      message:
                                          "Your Video has been saved Successfully",
                                      duration: 3,
                                      onCloseEvent: () {
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      },
                                    ));
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xffF9504D),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(height * 0.009),
                            child: Text(
                              'Save',
                              style: GoogleFonts.poppins(color: Colors.white),
                            ),
                          ),
                        )),
                  ],
                  backgroundColor: const Color.fromARGB(255, 248, 208, 208),
                );
              });
        });
  }
}
