import 'package:flutter/widgets.dart';
import 'package:project_tengkulaku_app/screens/homepage_petani/home_petani.dart';
import 'package:project_tengkulaku_app/screens/homepage_tengkulak/menu_pesan_tengkulak.dart';
import 'package:project_tengkulaku_app/screens/login/login_screen.dart';
import 'package:project_tengkulaku_app/screens/homepage_petani/navigationbar_petani.dart';
import 'package:project_tengkulaku_app/screens/otp/otp_screen.dart';
import 'package:project_tengkulaku_app/screens/registrasi/registrasi_screen.dart';
import 'package:project_tengkulaku_app/screens/splash/splash_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  // ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  HomePetani.routeName: (context) => HomePetani(),
  OtpScreen.routeName: (context) => OtpScreen(),
  PesanTengkulak.routeName: (context) => PesanTengkulak(),
  BottomNavigationBarExample.routeName: (context) =>
      BottomNavigationBarExample(),
};
