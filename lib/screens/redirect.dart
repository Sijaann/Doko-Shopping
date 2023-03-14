// import 'package:ecommerce/screens/login.dart';
// import 'package:ecommerce/screens/user/nav_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class RedirectPage extends StatefulWidget {
//   const RedirectPage({super.key});

//   @override
//   State<RedirectPage> createState() => _RedirectPageState();
// }

// class _RedirectPageState extends State<RedirectPage> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             return NavPage();
//           } else {
//             return Login();
//           }
//         });
//   }
// }
