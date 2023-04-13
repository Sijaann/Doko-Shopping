import 'package:ecommerce/screens/admin/admin_nav.dart';
import 'package:ecommerce/screens/login.dart';
import 'package:ecommerce/screens/user/home.dart';
import 'package:ecommerce/screens/user/nav_page.dart';
import 'package:ecommerce/screens/splash.dart';
import 'package:ecommerce/screens/vendor/vendorNav.dart';
import 'package:ecommerce/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    return KhaltiScope(
      publicKey: "test_public_key_d6b4ca03b1d54e9bab85f9a812600e21",
      builder: (context, navigatorKey) {
        return MaterialApp(
          title: "Doko Shopping",
          theme: ThemeData(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryColor,
            ),
          ),
          home: const Splash(),
          navigatorKey: navigatorKey,
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('ne', 'NP'),
          ],
          localizationsDelegates: const [KhaltiLocalizations.delegate],
        );
      },
    );
  }
}

class RedirectPage extends StatefulWidget {
  const RedirectPage({super.key});

  @override
  State<RedirectPage> createState() => _RedirectPageState();
}

class _RedirectPageState extends State<RedirectPage> {
  String? userRole;

  void getUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userRole = prefs.getString('userRole');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserRole();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (userRole == "Admin") {
            return const AdminNav();
          } else if (userRole == "Vendor") {
            return const VendorNav();
          } else {
            return const NavPage();
          }
        } else {
          return const NavPage();
        }
      },
    );
  }
}
