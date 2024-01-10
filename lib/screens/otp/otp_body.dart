import 'package:flutter/material.dart';
import 'package:project_tengkulaku_app/auth/auth_service.dart';
import 'package:project_tengkulaku_app/komponen/button.dart';
import 'package:project_tengkulaku_app/konfigurasi_layar.dart';
import 'package:project_tengkulaku_app/konstan.dart';
import 'package:project_tengkulaku_app/screens/otp/otp_form.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final TextEditingController phoneNumberController = TextEditingController();
  final List<String?> errors = [];

  void addError({String? error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String? error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  bool ValidasiNomorTelepon() {
    String phoneNumber = phoneNumberController.text.trim();
    if (phoneNumber.isEmpty) {
      print("Nomor telepon kosong");
      return false;
    } else if (phoneNumber.length < 10 || phoneNumber.length > 15) {
      return false;
    } else {
      return true;
    }
  }

  int currentPage = 0;
  PageController _pageController = PageController(initialPage: 0);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenWidth(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: getProportionateScreenHeight(20)),
            Text(
              currentPage == 0 ? "Masukkan Nomor Telepon" : "Verifikasi OTP",
              style: headingStyle,
            ),
            SizedBox(height: getProportionateScreenHeight(30)),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (value) {
                  setState(() {
                    currentPage = value;
                  });
                },
                children: [
                  buildPhoneNumberPage(),
                  buildOtpVerificationPage(),
                ],
              ),
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            GestureDetector(
              onTap: () {
                if (currentPage == 0) {
                  if (ValidasiNomorTelepon()) {
                    _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease,
                    );
                  }
                } else {}
              },
              child: currentPage == 0
                  ? DefaultButton(
                      text: "Kirim Kode OTP",
                      press: () async {
                        if (ValidasiNomorTelepon()) {
                          await authKirimOtp(phoneNumberController.text.trim());
                          _pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.ease,
                          );
                        }
                      },
                    )
                  : GestureDetector(
                      onTap: () async {
                        if (ValidasiNomorTelepon()) {
                          await authKirimOtp(phoneNumberController.text.trim());
                          // _pageController.nextPage(
                          //     duration: Duration(milliseconds: 300),
                          //     curve: Curves.ease);
                        }
                      },
                      child: Center(
                        child: Text(
                          "Kirim Ulang Kode OTP",
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: getProportionateScreenWidth(14),
                          ),
                        ),
                      ),
                    ),
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
          ],
        ),
      ),
    );
  }

  Widget buildPhoneNumberPage() {
    return Column(
      children: [
        NomorTeleponField(),
        // Text(
        //     "Kode verifikasi akan dikirim ke nomor telepon yang Anda masukkan"),
      ],
    );
  }

  Widget buildOtpVerificationPage() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            buildTimer(),
            OtpForm(),
          ],
        ),
      ),
    );
  }

  TextFormField NomorTeleponField() {
    phoneNumberController.text = "+62";
    return TextFormField(
      controller: phoneNumberController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: "Nomor Telepon",
        hintText: "Masukkan nomor telepon Anda",
        suffixIcon: Icon(Icons.phone),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  Widget buildTimer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Kode OTP Akan Valid Sampai "),
        TweenAnimationBuilder(
          tween: Tween(begin: 120.0, end: 0.0),
          duration: Duration(minutes: 2),
          builder: (_, dynamic value, child) => Text(
            "0${value ~/ 60}:${(value % 60).toInt().toString().padLeft(2, '0')}",
            style: TextStyle(color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
}
