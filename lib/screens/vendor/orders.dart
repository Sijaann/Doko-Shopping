import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/utils/app_text.dart';
import 'package:ecommerce/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
      // body: StreamBuilder<QuerySnapshot>(
      //   stream: FirebaseFirestore.instance
      //       .collection('orders')
      //       .where('vendorId', isEqualTo: user.uid)
      //       .snapshots(),
      //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //     if (snapshot.hasError) {
      //       return const Center(
      //         child: AppText(
      //           text: "Something went wrong",
      //           color: AppColors.primaryColor,
      //           weight: FontWeight.w500,
      //         ),
      //       );
      //     }

      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }

      //     final List<ListTile> orderTiles = snapshot.data!.docs
      //         .map(
      //           (DocumentSnapshot document) => ListTile(
      //             title: AppText(
      //               text: document['name'],
      //               color: AppColors.primaryColor,
      //               size: 15,
      //             ),
      //           ),
      //         )
      //         .toList();
      //   },
      // ),
    );
  }
}
