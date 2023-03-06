import 'package:ecommerce/screens/signup.dart';
import 'package:ecommerce/screens/splash.dart';
import 'package:ecommerce/utils/colors.dart';
import 'package:flutter/material.dart';

void main() {
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
      home: const Splash(),
    );
  }
}
