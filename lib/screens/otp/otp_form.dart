import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_tengkulaku_app/komponen/button.dart';
import 'package:project_tengkulaku_app/konfigurasi_layar.dart';
import 'package:project_tengkulaku_app/konstan.dart';
import 'package:project_tengkulaku_app/screens/login/login_screen.dart';

class OtpForm extends StatefulWidget {
  const OtpForm({
    Key? key,
  }) : super(key: key);

  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  final TextEditingController otpController1 = TextEditingController();
  final TextEditingController otpController2 = TextEditingController();
  final TextEditingController otpController3 = TextEditingController();
  final TextEditingController otpController4 = TextEditingController();
  final TextEditingController otpController5 = TextEditingController();
  final TextEditingController otpController6 = TextEditingController();

  // @override
  // void dispose() {
  //   otpController1.dispose();
  //   otpController2.dispose();
  //   otpController3.dispose();
  //   otpController4.dispose();
  //   otpController5.dispose();
  //   otpController6.dispose();
  //   super.dispose();
  // }

  FocusNode? pin2FocusNode;
  FocusNode? pin3FocusNode;
  FocusNode? pin4FocusNode;
  FocusNode? pin5FocusNode;
  FocusNode? pin6FocusNode;

  set verificationId(String verificationId) {}

  @override
  void initState() {
    super.initState();
    pin2FocusNode = FocusNode();
    pin3FocusNode = FocusNode();
    pin4FocusNode = FocusNode();
    pin5FocusNode = FocusNode();
    pin6FocusNode = FocusNode();
  }

  @override
  void dispose() {
    super.dispose();
    pin2FocusNode!.dispose();
    pin3FocusNode!.dispose();
    pin4FocusNode!.dispose();
    pin5FocusNode!.dispose();
    pin6FocusNode!.dispose();
  }

  void nextField(String value, FocusNode? focusNode) {
    if (value.length == 1) {
      focusNode!.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.12,
                child: TextFormField(
                  controller: otpController1,
                  autofocus: true,
                  obscureText: true,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    nextField(value, pin2FocusNode);
                  },
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.12,
                child: TextFormField(
                  controller: otpController2,
                  focusNode: pin2FocusNode,
                  obscureText: true,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) => nextField(value, pin3FocusNode),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.12,
                child: TextFormField(
                  controller: otpController3,
                  focusNode: pin3FocusNode,
                  obscureText: true,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) => nextField(value, pin4FocusNode),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.12,
                child: TextFormField(
                  controller: otpController4,
                  focusNode: pin4FocusNode,
                  obscureText: true,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) => nextField(value, pin5FocusNode),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.12,
                child: TextFormField(
                  controller: otpController5,
                  focusNode: pin5FocusNode,
                  obscureText: true,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) => nextField(value, pin6FocusNode),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.12,
                child: TextFormField(
                  controller: otpController6,
                  focusNode: pin6FocusNode,
                  obscureText: true,
                  style: TextStyle(fontSize: 24),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  decoration: otpInputDecoration,
                  onChanged: (value) {
                    if (value.length == 1) {
                      pin6FocusNode!.unfocus();
                    }
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: SizeConfig.screenHeight * 0.15),
          DefaultButton(
            text: "Lanjutkan",
            press: () async {
              String phoneNumber = '+6282233878525';
              String? verificationId;

              // Menjalankan proses verifikasi nomor telepon
              await FirebaseAuth.instance.verifyPhoneNumber(
                phoneNumber: phoneNumber,
                verificationCompleted: (PhoneAuthCredential credential) {},
                verificationFailed: (FirebaseAuthException e) {
                  print('Error: ${e.message}');
                },
                codeSent: (String verId, int? resendToken) {
                  // Menyimpan verificationId yang diterima dari Firebase
                  print("Verification ID: $verId");
                  setState(() {
                    verificationId = verId;
                  });
                },
                codeAutoRetrievalTimeout: (String verId) {},
                timeout: Duration(seconds: 120),
              );

              // Lakukan verifikasi OTP setelah pengguna memasukkan kode OTP pada TextField dan menekan tombol
              String otp =
                  '${otpController1.text}${otpController2.text}${otpController3.text}${otpController4.text}${otpController5.text}${otpController6.text}';
              try {
                // Memastikan verificationId tidak null atau kosong sebelum menggunakan PhoneAuthProvider
                if (verificationId != null && verificationId!.isNotEmpty) {
                  // Verifikasi OTP menggunakan PhoneAuthProvider
                  AuthCredential credential = PhoneAuthProvider.credential(
                    verificationId: verificationId!,
                    smsCode: otp,
                  );
                  UserCredential userCredential = await FirebaseAuth.instance
                      .signInWithCredential(credential);

                  // Verifikasi berhasil, tambahkan logika untuk navigasi atau tindakan setelah verifikasi OTP berhasil
                  if (userCredential.user != null) {
                    // Navigasi ke layar selanjutnya setelah verifikasi berhasil
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignInScreen()),
                    );
                  }
                } else {
                  print('Invalid verificationId');
                }
              } catch (e) {
                print("Error during OTP verification: $e");
              }
            },
          )
        ],
      ),
    );
  }
}
