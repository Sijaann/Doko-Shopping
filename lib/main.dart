import 'package:ecommerce/screens/admin/admin_nav.dart';
import 'package:ecommerce/screens/login.dart';
import 'package:ecommerce/screens/user/nav_page.dart';
import 'package:ecommerce/screens/signup.dart';
import 'package:ecommerce/screens/splash.dart';
import 'package:ecommerce/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ECommerce());
}

class ECommerce extends StatefulWidget {
  const ECommerce({super.key});

  @override
  State<ECommerce> createState() => _ECommerceState();
}

class _ECommerceState extends State<ECommerce> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Doko Shopping",
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: AppColors.primaryColor,
        ),
      ),
      home: Splash(),
    );
  }
}

class RedirectPage extends StatefulWidget {
  const RedirectPage({super.key});

  @override
  State<RedirectPage> createState() => _RedirectPageState();
}

class _RedirectPageState extends State<RedirectPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return NavPage();
        } else {
          return Login();
        }
      },
    );
  }
}
