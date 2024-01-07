import 'package:flutter/material.dart';
import 'package:project_tengkulaku_app/konfigurasi_layar.dart';
import 'package:project_tengkulaku_app/konstan.dart';
import 'package:project_tengkulaku_app/screens/registrasi/registrasi_screen.dart';

class NoAccountText extends StatelessWidget {
  const NoAccountText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Belum mempunyai akun? ",
          style: TextStyle(fontSize: getProportionateScreenWidth(15)),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, SignUpScreen.routeName),
          child: Text(
            "Buat akun baru",
            style: TextStyle(
                fontSize: getProportionateScreenWidth(15),
                color: kPrimaryColor),
          ),
        ),
      ],
    );
  }
}
