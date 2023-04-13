import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/utils/app_text.dart';
import 'package:ecommerce/utils/colors.dart';
import 'package:flutter/material.dart';

class RevenueScreen extends StatefulWidget {
  const RevenueScreen({super.key});

  @override
  State<RevenueScreen> createState() => _RevenueScreenState();
}

class _RevenueScreenState extends State<RevenueScreen> {
  double totalRevenue = 0.0;
  int totalOrders = 0;

  void getTotalServiceTax() {
    double totalServiceTax = 0;

    FirebaseFirestore.instance.collection('orders').get().then((querySnapshot) {
      final int length = querySnapshot.size;
      totalOrders = length;
      for (var doc in querySnapshot.docs) {
        final orderData = doc.data();
        final double serviceTax = orderData['serviceTax'] ?? 0;
        totalServiceTax += serviceTax;
      }
      // print('Total Service Tax: $totalServiceTax');
      setState(() {
        totalRevenue = totalServiceTax;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getTotalServiceTax();
    // print(totalRevenue);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: const Center(
              child: AppText(
                text: "Total Revenue",
                color: AppColors.secondaryColor,
              ),
            ),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppText(
              text: "Total Orders",
              color: AppColors.primaryColor,
              size: 25,
              weight: FontWeight.w600,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: AppText(
                    text: "$totalOrders",
                    color: Colors.green,
                    weight: FontWeight.bold,
                    size: 23,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            const AppText(
              text: "Total Revenue",
              color: AppColors.primaryColor,
              size: 25,
              weight: FontWeight.w600,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: AppText(
                    text: "Rs. $totalRevenue",
                    color: Colors.green,
                    weight: FontWeight.bold,
                    size: 23,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
