import 'package:flutter/material.dart';
import 'package:navni_sangraha/screens/auth/login_screen.dart';
import 'package:navni_sangraha/screens/splash/splash_screen.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SplashScreen());
    // return MaterialApp(home: LoginScreen());
  }
}
