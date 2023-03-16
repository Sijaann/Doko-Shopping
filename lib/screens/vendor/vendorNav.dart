import 'package:ecommerce/screens/vendor/orders.dart';
import 'package:ecommerce/screens/vendor/vendor_home.dart';
import 'package:ecommerce/utils/colors.dart';
import 'package:flutter/material.dart';

class VendorNav extends StatefulWidget {
  const VendorNav({super.key});

  @override
  State<VendorNav> createState() => _VendorNavState();
}

class _VendorNavState extends State<VendorNav> {
  List _pages = [
    VendorHome(),
    Orders(),
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
            icon: Icon(Icons.receipt_long_outlined),
            label: "Orders",
          )
        ],
      ),
      body: _pages[currentIndex],
    );
  }
}
