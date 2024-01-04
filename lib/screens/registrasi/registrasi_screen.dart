import 'package:flutter/material.dart';
import 'package:project_tengkulaku_app/konfigurasi_layar.dart';
import 'package:project_tengkulaku_app/konstan.dart';
import 'package:project_tengkulaku_app/screens/registrasi/registrasi_form.dart';

class SignUpScreen extends StatelessWidget {
  static String routeName = "/sign_up";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(20)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 16),
                  Text("Registrasi Akun Baru", style: headingStyle),
                  Text(
                    "Selesaikan Detail Informasi Akun Anda!",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.08),
                  SignUpForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
