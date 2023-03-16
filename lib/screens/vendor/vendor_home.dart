import 'package:ecommerce/screens/login.dart';
import 'package:ecommerce/screens/vendor/add_poduct.dart';
import 'package:ecommerce/utils/app_text.dart';
import 'package:ecommerce/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VendorHome extends StatefulWidget {
  const VendorHome({super.key});

  @override
  State<VendorHome> createState() => _VendorHomeState();
}

class _VendorHomeState extends State<VendorHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProduct(),
            ),
          );
        },
        backgroundColor: AppColors.primaryColor,
        tooltip: "Add Products",
        child: const Icon(
          Icons.add,
          color: AppColors.secondaryColor,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: AppText(
            text: "Vendor",
            color: AppColors.secondaryColor,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: IconButton(
              onPressed: logout,
              icon: const Icon(Icons.logout_rounded),
            ),
          ),
        ],
      ),
    );
  }

  logout() {
    FirebaseAuth.instance.signOut().then(
          (value) => setState(
            () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => Login()));
            },
          ),
        );
  }
}
