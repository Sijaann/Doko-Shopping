import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/screens/admin/admin_nav.dart';
import 'package:ecommerce/screens/signup.dart';
import 'package:ecommerce/screens/user/nav_page.dart';
import 'package:ecommerce/screens/vendor/vendorNav.dart';
import 'package:ecommerce/utils/app_text.dart';
import 'package:ecommerce/utils/app_textfield.dart';
import 'package:ecommerce/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? _user;

  void _login() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      _getCurrentUser();
    } on FirebaseAuthException catch (e) {
      print('Login failed: ${e.message}');
    }
  }

  void _getCurrentUser() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get()
          .then((value) {
        if (value.data()!['userType'] == "admin") {
          setState(() {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AdminNav(),
              ),
            );
          });
        }
        if (value.data()!['userType'] == "User") {
          setState(() {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => NavPage(),
              ),
            );
          });
        }
        if (value.data()!['userType'] == "Vendor") {
          setState(() {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => VendorNav(),
              ),
            );
          });
        }
      });
    }
  }

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
                              onPressed: () async {
                                // if (_formkey.currentState!.validate()) {
                                //   login(_emailController.text,
                                //       _passwordController.text);
                                // }
                                if (_formkey.currentState!.validate()) {
                                  _login();
                                  // try {
                                  //   final userCredential = await FirebaseAuth
                                  //       .instance
                                  //       .signInWithEmailAndPassword(
                                  //     email: _emailController.text,
                                  //     password: _passwordController.text,
                                  //   );
                                  //   // print(userCredential);
                                  //   final user = userCredential.user!;
                                  //   final userData = await FirebaseFirestore
                                  //       .instance
                                  //       .collection('users')
                                  //       .doc(user.uid)
                                  //       .get();
                                  //   print('User data: ${userData.data()}');
                                  // } on FirebaseAuthException catch (e) {
                                  //   print('Login failed: ${e.message}');
                                  // }
                                  // getUserId();
                                  // print("$_userData!['name']");

                                  // setState(
                                  //   () {
                                  //     Navigator.pushReplacement(
                                  //         context,
                                  //         MaterialPageRoute(
                                  //             builder: (context) => NavPage()));
                                  //   },
                                  // );
                                  // getUserName();

                                  // getUserId();
                                  // getUserData(userID);
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
                        // SizedBox(
                        //   height: 50,
                        //   child: _user == null
                        //       ? const CircularProgressIndicator()
                        //       : Text("Name: ${userData!['name']}"),
                        // ),
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

  Future login(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    //   //     .then((value) {
    //   //   setState(() {
    //   //     Navigator.pushReplacement(
    //   //         context, MaterialPageRoute(builder: (context) => NavPage()));
    //   //   });
    //   // });
  }

  // var userID;
  // getUserId() {
  //   FirebaseAuth.instance.authStateChanges().listen((User? user) {
  //     if (user != null) {
  //       userID = user.uid;
  //       print(user.uid);
  //     }
  //   });
  // }

  // Future<DocumentSnapshot> getUserData(String userId) async {
  //   final usersRef = FirebaseFirestore.instance.collection('users');

  //   final userDoc = await usersRef.doc(userId).get();
  //   return userDoc;
  // }
}
