import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/screens/vendor/order_detail_screen.dart';
import 'package:ecommerce/utils/app_text.dart';
import 'package:ecommerce/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  final User user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: AppText(
            text: "Orders",
            color: AppColors.secondaryColor,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('orders')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: AppText(
                text: "Something went wrong",
                color: AppColors.primaryColor,
                weight: FontWeight.w500,
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final List<ListTile> orderTiles = snapshot.data!.docs
              .map(
                (DocumentSnapshot document) => ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OrderDetails(documentId: document.id),
                      ),
                    );
                  },
                  title: AppText(
                    text: document['date'],
                    color: AppColors.primaryColor,
                    size: 15,
                  ),
                  subtitle: AppText(
                    text:
                        "Total Number of items: ${document['products'].length}",
                    color: AppColors.hintTextColor,
                    size: 15,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios),
                ),
              )
              .toList();

          return (orderTiles.isEmpty)
              ? const Center(
                  child: AppText(
                    text: "No orders yet",
                    color: AppColors.primaryColor,
                    weight: FontWeight.w500,
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8),
                  child: ListView.builder(
                    itemCount: orderTiles.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 2,
                          child: orderTiles[index],
                        ),
                      );
                    },
                  ),
                );
        },
      ),
      // body: ,
    );
  }
}
