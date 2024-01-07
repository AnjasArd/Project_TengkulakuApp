import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project_tengkulaku_app/konfigurasi_layar.dart';
import 'package:project_tengkulaku_app/routes.dart';
import 'package:project_tengkulaku_app/screens/homepage_petani/navigationbar_petani.dart';
import 'package:project_tengkulaku_app/screens/splash/splash_screen.dart';
import 'package:project_tengkulaku_app/tema.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        SizeConfig().init(context);
        return child!;
      },
      debugShowCheckedModeBanner: false,
      title: 'Tengkulaku App',
      theme: AppTheme.lightTheme(context),
      initialRoute: SplashScreen.routeName,
      routes: routes,
      home: BottomNavigationBarExample(),
    );
  }
}
