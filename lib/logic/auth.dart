import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/admin/admin_nav.dart';
import '../screens/user/nav_page.dart';
import '../screens/vendor/vendorNav.dart';
import '../utils/show_shanckbar.dart';

class Auth {
  void login(
      {required FirebaseAuth auth,
      required String email,
      required String password,
      required BuildContext context}) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      getCurrentUser(context: context);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  void getCurrentUser({required BuildContext context}) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get()
          .then((value) {
        if (value.data()!['userType'] == "Admin") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AdminNav(),
            ),
          );
        }
        if (value.data()!['userType'] == "User") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const NavPage(),
            ),
          );
        }
        if (value.data()!['userType'] == "Vendor") {
          if (value.data()!['userType'] == "Vendor" &&
              value.data()!['status'] == "verified") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const VendorNav(),
              ),
            );
          }
          if (value.data()!['userType'] == "Vendor" &&
              value.data()!['status'] == "unverified") {
            showSnackBar(context,
                "Your Account is yet to be verified by admin. Please try again later!");
          }
        }
      });
    }
  }

  // REGISTERING USER TO THE DATABASE AND STORING USER DATA TO FIRESTORE
  void register({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required BuildContext context,
    required String email,
    required String password,
    required String name,
    required String contact,
    required String userType,
    required String status,
    String? address = "",
    required List cart,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required TextEditingController contactController,
    required TextEditingController nameController,
  }) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      String uid = userCredential.user!.uid;
      // String name = _nameController.text.trim();
      // String contact = _contactController.text.trim();
      // String email = _emailController.text.trim();
      // String userTypeVal = userTypeValue.toString();

      if (userType == "User") {
        await firestore.collection('users').doc(uid).set({
          'userId': uid,
          'name': name,
          'contact': contact,
          'email': email,
          'address': address,
          'userType': userType,
          'status': status,
          'cart': cart,
        }).then((value) {
          if (status == "verified") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const NavPage(),
              ),
            );
          }
          if (status == "unverified") {
            showSnackBar(context,
                "Vendor account yet to be verified by admin. Please wait!");
            nameController.clear();
            contactController.clear();
            emailController.clear();
            passwordController.clear();
          }
        });
      } else {
        await firestore.collection('users').doc(uid).set({
          'userId': uid,
          'name': name,
          'contact': contact,
          'email': email,
          'userType': userType,
          'status': status,
        }).then((value) {
          if (status == "verified") {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const NavPage(),
              ),
            );
          }
          if (status == "unverified") {
            showSnackBar(context,
                "Vendor account yet to be verified by admin. Please wait!");
            nameController.clear();
            contactController.clear();
            emailController.clear();
            passwordController.clear();
          }
        });
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
