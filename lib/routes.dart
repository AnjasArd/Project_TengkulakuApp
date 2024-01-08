import 'package:flutter/widgets.dart';
import 'package:project_tengkulaku_app/screens/homepage_petani/home_petani.dart';
import 'package:project_tengkulaku_app/screens/homepage_petani/kelola_produk.dart';
import 'package:project_tengkulaku_app/screens/homepage_petani/menu_pesan_petani.dart';
import 'package:project_tengkulaku_app/screens/homepage_petani/tambah_produk.dart';
import 'package:project_tengkulaku_app/screens/homepage_tengkulak/menu_pesan_tengkulak.dart';
import 'package:project_tengkulaku_app/screens/homepage_tengkulak/navigationbar_tengkulak.dart';
import 'package:project_tengkulaku_app/screens/login/login_screen.dart';
import 'package:project_tengkulaku_app/screens/homepage_petani/navigationbar_petani.dart';
import 'package:project_tengkulaku_app/screens/otp/otp_screen.dart';
import 'package:project_tengkulaku_app/screens/registrasi/registrasi_screen.dart';
import 'package:project_tengkulaku_app/screens/splash/splash_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  HomePetani.routeName: (context) => HomePetani(),
  OtpScreen.routeName: (context) => OtpScreen(),
  PesanTengkulak.routeName: (context) => PesanTengkulak(),
  PesanPetani.routeName: (context) => PesanPetani(),
  TambahProduk.routeName: (context) => TambahProduk(),
  KelolaProduk.routeName: (context) => KelolaProduk(),
  BottomNavigationBarPetani.routeName: (context) => BottomNavigationBarPetani(),
  BottomNavigationBarTengkulak.routeName: (context) =>
      BottomNavigationBarTengkulak(),
};
