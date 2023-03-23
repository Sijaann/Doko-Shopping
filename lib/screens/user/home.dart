import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/logic/logout.dart';
import 'package:ecommerce/screens/login.dart';
import 'package:ecommerce/screens/user/all_products.dart';
import 'package:ecommerce/screens/user/product_detail.dart';
import 'package:ecommerce/utils/app_text.dart';
import 'package:ecommerce/utils/colors.dart';
import 'package:ecommerce/utils/product_grid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List image = [
    "https://images.unsplash.com/photo-1542291026-7eec264c27ff?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80",
    "https://images.unsplash.com/photo-1626753846051-29b988f34fd4?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80",
    "https://images.unsplash.com/photo-1507764923504-cd90bf7da772?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80",
    "https://images.unsplash.com/photo-1592842232655-e5d345cbc2d0?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=774&q=80",
  ];

  final User user = FirebaseAuth.instance.currentUser!;
  final SignOut signOut = SignOut();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: AppText(
              text: "Doko Shopping",
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
        // body: SingleChildScrollView(
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Container(
        //         height: MediaQuery.of(context).size.height * 0.3,
        //         width: MediaQuery.of(context).size.width,
        //         color: Colors.amber,
        //         child: ListView.builder(
        //             scrollDirection: Axis.horizontal,
        //             itemCount: image.length,
        //             itemBuilder: (context, index) {
        //               return SizedBox(
        //                 width: MediaQuery.of(context).size.width,
        //                 child: Image.network(
        //                   image[index],
        //                   fit: BoxFit.fitWidth,
        //                 ),
        //               );
        //             }),
        //       ),
        //       Padding(
        //         padding:
        //             const EdgeInsets.symmetric(horizontal: 15).copyWith(top: 10),
        //         child: const AppText(
        //           text: "All Products",
        //           color: AppColors.primaryColor,
        //           weight: FontWeight.w500,
        //         ),
        //       ),
        //       Padding(
        //         padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        //         child: SizedBox(
        //           height: MediaQuery.of(context).size.height * 0.8,
        //           width: MediaQuery.of(context).size.width,
        //           // color: Colors.orange,
        //           child: GridView.builder(
        //             itemCount: 50,
        //             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //                 crossAxisCount: 2),
        //             itemBuilder: (context, index) {
        //               return GestureDetector(
        //                 onTap: () {
        //                   Navigator.push(
        //                       context,
        //                       MaterialPageRoute(
        //                           builder: (context) => const ProductDetail()));
        //                 },
        //                 child: Padding(
        //                   padding: const EdgeInsets.all(4),
        //                   child: Card(
        //                     shape: RoundedRectangleBorder(
        //                       borderRadius: BorderRadius.circular(15),
        //                     ),
        //                     elevation: 4,
        //                     child: Container(
        //                       decoration: BoxDecoration(
        //                         borderRadius: BorderRadius.circular(15),
        //                       ),
        //                       height: 150,
        //                       width: 150,
        //                       child: Column(
        //                         children: [
        //                           Container(
        //                             decoration: const BoxDecoration(
        //                               borderRadius: BorderRadius.only(
        //                                 topLeft: Radius.circular(15),
        //                                 topRight: Radius.circular(15),
        //                               ),
        //                             ),
        //                             width: double.maxFinite,
        //                             height:
        //                                 MediaQuery.of(context).size.height * 0.14,
        //                             child: ClipRRect(
        //                               borderRadius: const BorderRadius.only(
        //                                 topLeft: Radius.circular(15),
        //                                 topRight: Radius.circular(15),
        //                               ),
        //                               child: Image.network(
        //                                 "https://images.unsplash.com/photo-1616423640778-28d1b53229bd?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80",
        //                                 fit: BoxFit.cover,
        //                               ),
        //                             ),
        //                           ),
        //                           Container(
        //                             width: double.maxFinite,
        //                             height: MediaQuery.of(context).size.height *
        //                                 0.0655,
        //                             decoration: const BoxDecoration(
        //                               borderRadius: BorderRadius.only(
        //                                 bottomLeft: Radius.circular(15),
        //                                 bottomRight: Radius.circular(15),
        //                               ),
        //                               color: AppColors.primaryColor,
        //                             ),
        //                             child: Padding(
        //                               padding: const EdgeInsets.all(4.0),
        //                               child: Row(
        //                                 mainAxisAlignment:
        //                                     MainAxisAlignment.spaceBetween,
        //                                 children: [
        //                                   Column(
        //                                     mainAxisAlignment:
        //                                         MainAxisAlignment.spaceEvenly,
        //                                     children: const [
        //                                       AppText(
        //                                         text: "Camera",
        //                                         color: AppColors.secondaryColor,
        //                                         size: 16,
        //                                         weight: FontWeight.w500,
        //                                       ),
        //                                       AppText(
        //                                         text: "Rs. 50000",
        //                                         color: AppColors.secondaryColor,
        //                                         size: 13,
        //                                       )
        //                                     ],
        //                                   ),
        //                                   const Icon(
        //                                     Icons.add_circle_outline_rounded,
        //                                     color: AppColors.secondaryColor,
        //                                   )
        //                                 ],
        //                               ),
        //                             ),
        //                           )
        //                         ],
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //               );
        //             },
        //           ),
        //         ),
        //       ),
        //     ],
        //   ),
        // ),

        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('products').snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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

            final List<GestureDetector> productGrid =
                snapshot.data!.docs.map((DocumentSnapshot document) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetail(
                        images: document['images'],
                        name: document['productName'],
                        description: document['description'],
                        price: document['price'],
                        pId: document['productId'],
                        uId: user.uid,
                      ),
                    ),
                  );
                  print(user.uid);
                },
                child: ProductGrid(
                  imageString: document['images'][0],
                  name: document['productName'],
                  price: document['price'],
                  height: MediaQuery.of(context).size.height * 0.0721,
                ),
              );
            }).toList();

            return (productGrid.isEmpty)
                ? const Center(
                    child: AppText(
                      text: "No Products Found!",
                      color: AppColors.primaryColor,
                      weight: FontWeight.w500,
                    ),
                  )
                : SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.25,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.amber,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: image.length,
                            itemBuilder: (context, index) {
                              return SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: Image.network(
                                  image[index],
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15)
                              .copyWith(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const AppText(
                                text: "Featured Products",
                                color: AppColors.primaryColor,
                                weight: FontWeight.w500,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AllProducts(),
                                    ),
                                  );
                                },
                                child: const AppText(
                                  text: "See all",
                                  color: AppColors.hintTextColor,
                                  size: 15,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10)
                              .copyWith(top: 10),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.8,
                            width: MediaQuery.of(context).size.width,
                            child: GridView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: 4,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2),
                              itemBuilder: (context, index) {
                                return productGrid[index];
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
          },
        ));
  }

  logout() {
    FirebaseAuth.instance.signOut().then(
          (value) => setState(
            () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const Login(),
                ),
              );
            },
          ),
        );
  }
}
