// ignore_for_file: file_names

import 'package:clicks/auth.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_svg/svg.dart';

class PhoneNumberVerfication extends ConsumerStatefulWidget {
  const PhoneNumberVerfication({Key? key}) : super(key: key);

  @override
  ConsumerState<PhoneNumberVerfication> createState() =>
      _PhoneNumberVerficationState();
}

class _PhoneNumberVerficationState
    extends ConsumerState<PhoneNumberVerfication> {
  final TextEditingController _controller = TextEditingController();
  String dialCodeDigits = "+91";

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Padding(
            padding: EdgeInsets.only(top: height * 0.09),
            child: SvgPicture.asset(
              "images/login_page_.svg",
              width: width,
              height: height * 0.3,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: height * 0.05),
            child: const Center(
              child: Text(
                "Please Enter your Mobile Number",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
              ),
            ),
          ),
          // SizedBox(
          //   height: height * 0.02,
          // ),
          const Text(
            "You'll receive a 6 digit code",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          ),
          const Text(
            "for verification",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          ),
          SizedBox(
            height: height * 0.04,
          ),
          Container(
            height: height * 0.064,
            width: width * 0.9,
            decoration: BoxDecoration(
                border: Border.all(color: const Color(0xffF9504D), width: 1),
                borderRadius: BorderRadius.circular(10)),
            child: Row(children: [
              CountryCodePicker(
                onChanged: (country) {
                  setState(() {
                    dialCodeDigits = country.dialCode!;
                  });
                },
                initialSelection: "IN",
                showCountryOnly: false,
                showOnlyCountryWhenClosed: false,
                favorite: const ["+91"],
              ),
              const Text(
                "-",
                style: TextStyle(fontSize: 30),
              ),
              SizedBox(
                width: width * 0.06,
              ),
              Expanded(
                child: TextField(
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Mobile Number",
                    hintStyle: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey,
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  controller: _controller,
                ),
              ),
            ]),
          ),
          SizedBox(
            height: height * 0.05,
          ),
          SizedBox(
            height: height * 0.065,
            width: width * 0.9,
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      const Color(0xffF9504D),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ))),
                onPressed: () {
                  if (_controller.text != "") {
                    Auth.authWithPhone(context, _controller.text.trim(), "+91");
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Please enter a Mobile number"),
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                    ));
                  }
                },
                child: const Text(
                  "Next",
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )),
          ),
        ]),
      ),
    );
  }
}
