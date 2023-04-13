import 'dart:async';

import 'package:ecommerce/main.dart';
import 'package:ecommerce/utils/app_text.dart';
import 'package:ecommerce/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  Timer? _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timer = Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const RedirectPage(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            )
          ],
        ),
      ),
    );
  }
}
