// ignore_for_file: file_names, camel_case_types

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:clicks/PhoneNumberVerify.dart';
import 'package:clicks/VideoList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Landing_Page extends StatefulWidget {
  const Landing_Page({super.key});

  @override
  State<Landing_Page> createState() => _Landing_PageState();
}

class _Landing_PageState extends State<Landing_Page> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5)).then((value) {
      FirebaseAuth.instance.currentUser == null
          ? Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const PhoneNumberVerfication()))
          : Navigator.push(context,
              MaterialPageRoute(builder: (context) => const VedioList()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: SvgPicture.asset("images/logo_clicks.svg"),
      backgroundColor: Colors.white,
      splashIconSize: 100,
      nextScreen: FirebaseAuth.instance.currentUser == null
          ? const PhoneNumberVerfication()
          : const VedioList(),
      splashTransition: SplashTransition.fadeTransition,
    );
  }
}
