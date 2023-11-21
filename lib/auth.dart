// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:clicks/VideoList.dart';
import 'package:clicks/VerifyOtp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Auth {
  final FirebaseAuth auth = FirebaseAuth.instance;

  static Future authWithPhone(context, phoneNumber, code) async {
    print('------------------ auth with phone begins -----------------');
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    TextEditingController pinController = TextEditingController(text: "");
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: code + phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            if (kDebugMode) {
              print("verification completed");
            }
          },
          timeout: const Duration(seconds: 00),
          verificationFailed: (e) {
            if (kDebugMode) {
              print("verification failed, ${e.toString()}");
            }
            Fluttertoast.showToast(
                msg: 'Error occurred while accessing credentials. $e.');
          },
          codeSent: ((String verificationId, int? resendToken) async {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => VerifyOTP(
                  pinController: pinController,
                  phoneNumber: phoneNumber,
                  onCompleted: () async {
                    print(
                        '------------------ on completed begins -----------------');
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );
                    if (kDebugMode) {
                      print("Inputed Pin: ${pinController.text.trim()}");
                    }
                    if (pinController.text.trim().isEmpty ||
                        pinController.text.trim() == "") {
                      Fluttertoast.showToast(msg: 'Please enter a valid pin.');
                      Navigator.of(context).pop();
                    } else {
                      try {
                        PhoneAuthCredential credential =
                            PhoneAuthProvider.credential(
                          verificationId: verificationId,
                          smsCode: pinController.text.trim(),
                        );
                        UserCredential result = await FirebaseAuth.instance
                            .signInWithCredential(credential);

                        if (result.user != null) {
                          print("result: ${result.user!.uid}");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const VedioList()));
                        }

                        //inga next page navigation pathuko
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'invalid-verification-code') {
                          // ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          // ScaffoldMessenger.of(context).showSnackBar(
                          //   const SnackBar(
                          //     content: Text(
                          //       'Invalid OTP',
                          //     ),
                          //   ),
                          // );
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: const Duration(seconds: 2),
                              elevation: 6,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: Colors.red,
                              content: const Center(
                                child: Text(
                                  'Invalid OTP',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                          Navigator.pop(context);
                        } else if (e.code == 'invalid-credential') {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Error occurred while accessing credentials. Try again.',
                              ),
                            ),
                          );
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Error occurred while accessing credentials. Try again.',
                              ),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      }
                    }
                  },
                ),
              ),
            );
          }),
          codeAutoRetrievalTimeout: (String verificationId) {
            // Fluttertoast.showToast(msg: "OTP Timed Out");
          });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'The account already exists with a different credential',
            ),
          ),
        );
      } else if (e.code == 'invalid-credential') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Error occurred while accessing credentials. Try again.',
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Error occurred while accessing credentials. Try again.',
            ),
          ),
        );
      }
    }
  }
}
