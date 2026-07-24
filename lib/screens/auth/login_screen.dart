import 'package:flutter/material.dart';
import 'package:navni_sangraha/core/app_colors.dart';
import 'package:navni_sangraha/core/app_text_styles.dart';
import 'package:navni_sangraha/screens/dashboard/dashboard_screen.dart';
import 'package:navni_sangraha/widgets/buttons/primary_button.dart';
import 'package:navni_sangraha/widgets/inputs/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool rememberMe = false;
  bool isLoading = false;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future <void> loginUser() async{

    if(usernameController.text.trim().isEmpty){
      showMsg("Username is required.");
      return;
    }

    if(passwordController.text.trim().isEmpty){
      showMsg("Password is required.");
      return;
    }


    setState((){
      isLoading = true;
    });

    //wait for 3 seconds
    // await Future.delayed(const Duration(seconds: 3));


    if(!mounted) return;

    // Login uthentication is to be done here <<<<<<<<<<<<<<<<<<<<
    if(usernameController.text.trim() == "navni" && passwordController.text.trim() == "sang"){      
      // Redirecting to Dashboard
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashboardScreen(userName: usernameController.text.trim(),)));
    }else{
      showMsg("Invalid Username or Password");
      setState(() {
        isLoading = false;
      });
    }



  }

  void showMsg(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        // backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 30),

                // logo
                Center(
                  child: Image.asset(
                    "assets/navni_sangraha_logo.png",
                    width: 100,
                  ),
                ),

                // Space
                const SizedBox(height: 10),

                // Title
                const Text(
                  "NAVNI SANGRAHA",
                  textAlign: TextAlign.center,
                  style: AppTextStyles.primaryHeading,
                ),

                // Space
                const SizedBox(height: 10),

                // SubTitle
                const Text(
                  "Boutique ERP",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),

                // Space
                const SizedBox(height: 30),

                // Username
                CustomTextField(
                  label: "Username",
                  hint: "email or phone",
                  controller: usernameController,
                  prefixIcon: Icons.person_outline,
                ),

                // Space
                const SizedBox(height: 30),

                // password
                CustomTextField(
                  label: "Password",
                  hint: "Enter your password",
                  controller: passwordController,
                  prefixIcon: Icons.password,
                  isPassword: true,
                ),

                // Space
                const SizedBox(height: 30),

                // Remember me
                // --- Inkwell is used to handle the touch events on a non button widget
                InkWell(
                  onTap: () {
                    setState(() {
                      rememberMe = !rememberMe;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Checkbox(
                          value: rememberMe,
                          activeColor: AppColors.primaryDark,
                          checkColor: Colors.white,
                          onChanged: (value) {
                            setState(() {
                              rememberMe = value!;
                            });
                          },
                        ),

                        const Text(
                          "Remember Me",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),

                // Space
                const SizedBox(height: 10),

                // Login Button
                PrimaryButton(
                  text: "Login",
                  icon: Icons.login,
                  onPressed: loginUser,
                  isLoading: isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
