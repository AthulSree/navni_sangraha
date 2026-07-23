import 'package:flutter/material.dart';
import 'package:navni_sangraha/screens/splash/splash_screen_loader.dart';
import 'package:navni_sangraha/widgets/inputs/custom_text_field.dart';
import 'package:navni_sangraha/widgets/buttons/primary_button.dart';
import 'package:navni_sangraha/screens/auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool showLoader = false;

  Future<void> _startApp() async {
    // show Loader
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      showLoader = true;
    });

    // wait while the loader runs
    await Future.delayed(const Duration(seconds:3));

    if(!mounted) return;

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=> const LoginScreen()));
  }

  // Loads on runtime
  @override
  void initState() {
    super.initState();
    _startApp();
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

            // test widgets below
            // PrimaryButton(
            //   text: "SignIn",
            //   onPressed: () {
            //     print("Sign In btn pressed");
            //   },
            //   type: ButtonType.danger,
            //   icon: Icons.login,
            //   // isLoading: true,
            // ),

            // CustomTextField(label: "Username", hint: "Enter your username")
            // CustomTextField(label: "Username", hint: "Enter your username", prefixIcon: Icons.person,),

            // CustomTextField(label: "Username", hint: "Enter your username", prefixIcon: Icons.password, isPassword: true,)
          ],
        ),
      ),
    );
  }
}
