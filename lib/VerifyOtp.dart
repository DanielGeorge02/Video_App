// ignore_for_file: must_be_immutable, file_names, non_constant_identifier_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class VerifyOTP extends ConsumerStatefulWidget {
  final TextEditingController pinController;
  final String phoneNumber;
  final VoidCallback onCompleted;

  const VerifyOTP({
    super.key,
    required this.phoneNumber,
    required this.pinController,
    required this.onCompleted,
  });
  @override
  ConsumerState<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends ConsumerState<VerifyOTP> {
  // @override
  // void initState() {

  //   super.initState();
  //   verifyPhonenumber(phoneNo: widget.phoneNo, codedigit: widget.codedigit);
  // }

  String? VerificationCode;
  verifyPhonenumber({@required phoneNo, @required codedigit}) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: "${codedigit + phoneNo}",
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(e.message.toString()),
            duration: const Duration(seconds: 3),
          ));
        },
        codeSent: (String vID, int? resentToken) {
          setState(() {
            VerificationCode = vID;
          });
        },
        codeAutoRetrievalTimeout: (String vID) {
          setState(() {
            VerificationCode = vID;
          });
        },
        timeout: const Duration(seconds: 60));
  }

  // final TextEditingController _pinotpcontroller = TextEditingController();
  // final FocusNode _pinotpfocusnode = FocusNode();
  String? pins;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SvgPicture.asset("images/otp_page.svg"),
            Text(
              "Verifing Your Mobile Number",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700, fontSize: 21),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Text(
              "Otp sent to ${widget.phoneNumber}",
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            SizedBox(
              height: height * 0.04,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Pinput(
                  closeKeyboardWhenCompleted: false,
                  length: 6,
                  // focusNode: pinController,
                  controller: widget.pinController,
                  pinAnimationType: PinAnimationType.fade,
                  onCompleted: ((pin) {
                    setState(() {
                      // widget.pinController.text = pin;
                    });
                  }),
                  defaultPinTheme: PinTheme(
                    width: 50,
                    height: 50,
                    textStyle: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w600),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 250, 189, 188),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Didn't recieve the code?",
                  style: GoogleFonts.poppins(fontSize: 15),
                ),
                TextButton(
                  onPressed: () {
                    verifyPhonenumber(
                        phoneNo: widget.phoneNumber,
                        codedigit: widget.pinController);
                  },
                  child: Text(
                    "Request Again",
                    style: GoogleFonts.poppins(
                      color: const Color(0xffF9504D),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      // color: Appcolor.Apptheme
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(
                top: height * 0.045,
              ),
              child: SizedBox(
                height: height * 0.063,
                width: width * 0.85,
                child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: const MaterialStatePropertyAll(
                          Color(0xffF9504D),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ))),
                    onPressed: widget.onCompleted,
                    child: const Text(
                      "Get Started",
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
