import 'package:ecommerce/screens/admin/admin_home.dart';
import 'package:ecommerce/screens/admin/revenue.dart';
import 'package:ecommerce/screens/admin/vendor_request.dart';
import 'package:ecommerce/utils/colors.dart';
import 'package:flutter/material.dart';

class AdminNav extends StatefulWidget {
  const AdminNav({super.key});

  @override
  State<AdminNav> createState() => _AdminNavState();
}

class _AdminNavState extends State<AdminNav> {
  List _pages = [
    const AdminHome(),
    const VendorRequest(),
    const RevenueScreen(),
  ];

  int currentIndex = 0;

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTap,
        currentIndex: currentIndex,
        backgroundColor: AppColors.primaryColor,
        selectedItemColor: AppColors.secondaryColor,
        unselectedItemColor: AppColors.hintTextColor,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.verified),
            label: "Verify",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.currency_rupee),
            label: "Revenue",
          )
        ],
      ),
      body: _pages[currentIndex],
    );
  }
}
