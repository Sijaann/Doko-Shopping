import 'package:ecommerce/screens/login.dart';
import 'package:ecommerce/utils/app_text.dart';
import 'package:ecommerce/utils/app_textfield.dart';
import 'package:ecommerce/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 30,
            right: 30,
            top: 75,
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColors.primaryColor,
                        ),
                        child: Center(
                          child: Text(
                            "D",
                            style: GoogleFonts.montserrat(
                              fontSize: 48,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ),
                      const AppText(
                        text: "Doko",
                        color: AppColors.primaryColor,
                        size: 24,
                        style: FontStyle.italic,
                        weight: FontWeight.bold,
                      ),
                      const AppText(
                        text: "Shopping",
                        color: AppColors.primaryColor,
                        size: 16,
                        style: FontStyle.italic,
                        weight: FontWeight.bold,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 55),
                  child: SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 20),
                          child: AppText(
                            text: "Signup",
                            color: AppColors.primaryColor,
                            size: 24,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: AppTextField(
                            controller: _nameController,
                            hintText: "Full Name",
                            hide: false,
                            radius: 10,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: AppTextField(
                            controller: _contactController,
                            hintText: "Contact",
                            hide: false,
                            radius: 10,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: AppTextField(
                            controller: _emailController,
                            hintText: "Email",
                            hide: false,
                            radius: 10,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 18),
                          child: AppTextField(
                            controller: _passwordController,
                            hintText: "Password",
                            hide: true,
                            radius: 10,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 17),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: MaterialButton(
                              onPressed: () {},
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: AppColors.primaryColor,
                              child: const AppText(
                                text: "Signup",
                                color: AppColors.secondaryColor,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const AppText(
                              text: "Already have an account?",
                              color: AppColors.primaryColor,
                              size: 15,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Login(),
                                  ),
                                );
                              },
                              child: const AppText(
                                text: "Login",
                                color: AppColors.primaryColor,
                                size: 15,
                                weight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
