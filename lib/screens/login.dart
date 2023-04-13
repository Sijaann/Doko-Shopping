import 'package:ecommerce/screens/signup.dart';
import 'package:ecommerce/screens/user/nav_page.dart';
import 'package:ecommerce/utils/app_text.dart';
import 'package:ecommerce/utils/app_textfield.dart';
import 'package:ecommerce/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../logic/Auth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  var hidePassword = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Auth auth = Auth();

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
                            text: "Login",
                            color: AppColors.primaryColor,
                            size: 24,
                          ),
                        ),
                        Form(
                          key: _formkey,
                          child: Column(
                            children: [
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
                                  hide: hidePassword,
                                  radius: 10,
                                  iconButton: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        hidePassword = !hidePassword;
                                      });
                                    },
                                    icon: const Icon(Icons.remove_red_eye),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 17),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: MaterialButton(
                              onPressed: () {
                                if (_formkey.currentState!.validate()) {
                                  auth.login(
                                    auth: _auth,
                                    email: _emailController.text,
                                    password: _passwordController.text,
                                    context: context,
                                  );
                                }
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              color: AppColors.primaryColor,
                              child: const AppText(
                                text: "Login",
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
                              text: "Don't have an account?",
                              color: AppColors.primaryColor,
                              size: 15,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SignUp(),
                                  ),
                                );
                              },
                              child: const AppText(
                                text: "Signup",
                                color: AppColors.primaryColor,
                                size: 15,
                                weight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const NavPage(),
                                ),
                              );
                            },
                            child: const AppText(
                              text: "Skip",
                              color: AppColors.hintTextColor,
                              size: 18,
                            ),
                          ),
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
