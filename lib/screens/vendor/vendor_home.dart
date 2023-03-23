import 'dart:convert';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/logic/deleteData.dart';
import 'package:ecommerce/logic/logout.dart';
import 'package:ecommerce/screens/login.dart';
import 'package:ecommerce/screens/vendor/add_poduct.dart';
import 'package:ecommerce/screens/vendor/update_product.dart';
import 'package:ecommerce/utils/app_text.dart';
import 'package:ecommerce/utils/colors.dart';
import 'package:ecommerce/utils/show_shanckbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VendorHome extends StatefulWidget {
  const VendorHome({super.key});

  @override
  State<VendorHome> createState() => _VendorHomeState();
}

class _VendorHomeState extends State<VendorHome> {
  final User user = FirebaseAuth.instance.currentUser!;

  CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  DeleteData deleteData = DeleteData();

  final SignOut signOut = SignOut();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddProduct(),
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
              onPressed: () {
                signOut.logout(context: context);
              },
              icon: const Icon(Icons.logout_rounded),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products')
            .where('vendorId', isEqualTo: user.uid)
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

          final List<GestureDetector> productGrid = snapshot.data!.docs
              .map(
                (DocumentSnapshot document) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateProduct(
                          id: document['productId'],
                          name: document['productName'],
                          description: document['description'],
                          price: document['price'],
                          quantity: document['quantity'],
                          category: document['category'],
                          images: document['images'],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                            ),
                            width: double.maxFinite,
                            height: MediaQuery.of(context).size.height * 0.15,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                topRight: Radius.circular(15),
                              ),
                              child: Image.memory(
                                base64Decode(
                                  document['images'][0],
                                ),
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                          ),
                          Container(
                            width: double.maxFinite,
                            height: MediaQuery.of(context).size.height * 0.072,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(15),
                                bottomRight: Radius.circular(15),
                              ),
                              color: AppColors.primaryColor,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.345,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppText(
                                          text: document['productName'],
                                          color: AppColors.secondaryColor,
                                          size: 16,
                                          weight: FontWeight.w500,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        AppText(
                                          text: "Rs.${document['price']}",
                                          color: AppColors.secondaryColor,
                                          size: 13,
                                        )
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        // deleteProduct(
                                        //   id: document['productId'],
                                        // );
                                        deleteData.deleteProduct(
                                          id: document['productId'],
                                          reference: products,
                                          context: context,
                                        );
                                      });
                                    },
                                    child: const Icon(
                                      Icons.delete_outline_rounded,
                                      color: Colors.red,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
              .toList();

          return (productGrid.isEmpty)
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      AppText(
                        text: "No products listed yet",
                        color: AppColors.primaryColor,
                        weight: FontWeight.w500,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      AppText(
                        text: "Tap Add Button To Add Product",
                        color: AppColors.primaryColor,
                        weight: FontWeight.w500,
                      )
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10)
                      .copyWith(top: 10),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: GridView.builder(
                      itemCount: productGrid.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        return productGrid[index];
                      },
                    ),
                  ),
                );
        },
      ),
    );
  }
}
