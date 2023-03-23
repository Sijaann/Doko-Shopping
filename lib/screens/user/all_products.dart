import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/screens/user/product_detail.dart';
import 'package:ecommerce/utils/product_grid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/app_text.dart';
import '../../utils/colors.dart';

class AllProducts extends StatefulWidget {
  const AllProducts({super.key});

  @override
  State<AllProducts> createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  final Stream<QuerySnapshot> productStream =
      FirebaseFirestore.instance.collection('products').snapshots();

  final User user = FirebaseAuth.instance.currentUser!;

  // CollectionReference products =
  //     FirebaseFirestore.instance.collection('products');

  // final List storeDocs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: AppText(
            text: "All Products",
            color: AppColors.secondaryColor,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: productStream,
        builder:
            ((BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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

          final List<GestureDetector> productGrid = snapshot.data!.docs
              .map(
                (DocumentSnapshot document) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetail(
                          uId: user.uid,
                          images: document['images'],
                          name: document['productName'] as String,
                          description: document['description'] as String,
                          price: document['price'] as double,
                          pId: document['productId'],
                        ),
                      ),
                    );
                  },
                  child: ProductGrid(
                    imageString: document['images'][0],
                    name: document['productName'],
                    price: document['price'],
                    height: MediaQuery.of(context).size.height * 0.0758,
                  ),
                ),
              )
              .toList();

          // return (storeDocs.isEmpty)
          //     ? const Center(
          //         child: AppText(
          //           text: "No Products Listed",
          //           color: AppColors.primaryColor,
          //           weight: FontWeight.w600,
          //         ),
          //       )
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7)
                .copyWith(top: 5, bottom: 10),
            child: GridView.builder(
              itemCount: productGrid.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) {
                return productGrid[index];
              },
            ),
          );
        }),
      ),
    );
  }

  // Container dataGridContainer({required dynamic snapshot, required int index}) {
  //   successFunction(snapshot);

  //   return Container(
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.circular(15),
  //     ),
  //     child: Column(
  //       children: [
  //         Container(
  //           decoration: const BoxDecoration(
  //             borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(15),
  //               topRight: Radius.circular(15),
  //             ),
  //           ),
  //           width: double.maxFinite,
  //           height: MediaQuery.of(context).size.height * 0.15,
  //           child: ClipRRect(
  //             borderRadius: const BorderRadius.only(
  //               topLeft: Radius.circular(15),
  //               topRight: Radius.circular(15),
  //             ),
  //             child: Image.memory(
  //               base64Decode(
  //                 storeDocs[index]['images'][0],
  //               ),
  //               fit: BoxFit.fitHeight,
  //             ),
  //           ),
  //         ),
  //         Container(
  //           width: double.maxFinite,
  //           height: MediaQuery.of(context).size.height * 0.0755,
  //           decoration: const BoxDecoration(
  //             borderRadius: BorderRadius.only(
  //               bottomLeft: Radius.circular(15),
  //               bottomRight: Radius.circular(15),
  //             ),
  //             color: AppColors.primaryColor,
  //           ),
  //           child: Padding(
  //             padding:
  //                 const EdgeInsets.symmetric(vertical: 4).copyWith(left: 7),
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 AppText(
  //                   text: storeDocs[index]['productName'],
  //                   color: AppColors.secondaryColor,
  //                   size: 16,
  //                   weight: FontWeight.w500,
  //                 ),
  //                 AppText(
  //                   text: "Rs.${storeDocs[index]['price']}",
  //                   color: AppColors.secondaryColor,
  //                   size: 13,
  //                 )
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // void successFunction(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
  //   snapshot.data!.docs.map((DocumentSnapshot document) {
  //     Map docMap = document.data() as Map<String, dynamic>;
  //     storeDocs.add(docMap);
  //     docMap['id'] = document.id;
  //   }).toList();
  // }
}
