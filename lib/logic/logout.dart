import 'package:ecommerce/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignOut {
  logout({required BuildContext context}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    FirebaseAuth.instance.signOut().then((value) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Login(),
        ),
      );

      prefs.remove('userRole');
    });
  }
}
