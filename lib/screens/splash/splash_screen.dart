
import 'package:flutter/material.dart';
import 'package:navni_sangraha/screens/splash/splash_screen_loader.dart';
import 'package:navni_sangraha/widgets/inputs/custom_text_field.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool showLoader = false;

  // Loads on runtime
  @override
  void initState() {
    super.initState();
    // For delayed actions 
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        showLoader = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F13),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset("assets/splas_logo.png", width: 300),
            // SPace
            const SizedBox(height: 40),
            // Loader
            showLoader
                ? const SizedBox(
                    width: 100,
                    height: 100,
                    child: NeedleThreadLoader(),
                  )
                : const SizedBox(width: 100, height: 100),

            
            // CustomTextField(label: "Username", hint: "Enter your username")
            // CustomTextField(label: "Username", hint: "Enter your username", prefixIcon: Icons.person,),

            // CustomTextField(label: "Username", hint: "Enter your username", prefixIcon: Icons.password, isPassword: true,)
          ],
        ),
      ),
    );
  }
}


