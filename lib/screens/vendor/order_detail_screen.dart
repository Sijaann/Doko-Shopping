// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// import '../../utils/app_text.dart';
// import '../../utils/colors.dart';

// class OrderDetails extends StatefulWidget {
//   final String documentId;
//   const OrderDetails({
//     super.key,
//     required this.documentId,
//   });

//   @override
//   State<OrderDetails> createState() => _OrderDetailsState();
// }

// class _OrderDetailsState extends State<OrderDetails> {
//   final User user = FirebaseAuth.instance.currentUser!;

//   List productList = [];
//   var prod;
//   void getProductList() async {
//     final docRef = FirebaseFirestore.instance
//         .collection('users')
//         .doc(user.uid)
//         .collection('orders')
//         .doc(widget.documentId);

//     await docRef.get().then((DocumentSnapshot document) {
//       final data = document.data() as Map<String, dynamic>;

//       prod = data['products'] as List<dynamic>;

//       for (var item in prod) {
//         productList.add(item);
//       }

//       setState(() {});
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     print(widget.documentId);
//     getProductList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Padding(
//           padding: EdgeInsets.symmetric(
//             horizontal: 15,
//           ),
//           child: AppText(
//             text: "Order Detail",
//             color: AppColors.secondaryColor,
//           ),
//         ),
//       ),
//       body: productList == null
//           ? const Center(
//               child: CircularProgressIndicator(),
//             )
//           : SizedBox(
//               height: MediaQuery.of(context).size.height * 0.95,
//               width: MediaQuery.of(context).size.width,
//               child: SingleChildScrollView(
//                 physics: const BouncingScrollPhysics(),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       AppText(
//                         text: widget.documentId,
//                         color: AppColors.primaryColor,
//                       ),
//                       AppText(
//                         text: "Order Date",
//                         color: AppColors.primaryColor,
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           AppText(
//                             text: "Orders",
//                             color: AppColors.primaryColor,
//                           ),
//                           ElevatedButton(
//                             onPressed: () {},
//                             child: const AppText(
//                                 text: "Shipped",
//                                 color: AppColors.secondaryColor),
//                           )
//                         ],
//                       ),
//                       ListView.builder(
//                         physics: const NeverScrollableScrollPhysics(),
//                         shrinkWrap: true,
//                         itemCount: productList.length,
//                         itemBuilder: (context, index) {
//                           return Card(
//                             elevation: 2,
//                             child: ListTile(
//                               title: AppText(
//                                 text: productList[index]['pId'],
//                                 color: AppColors.primaryColor,
//                               ),
//                               subtitle: AppText(
//                                 text: productList[index]['price'].toString(),
//                                 color: AppColors.hintTextColor,
//                                 size: 15,
//                               ),
//                             ),
//                           );
//                         },
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//     );
//   }
// }

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/utils/app_button.dart';
import 'package:ecommerce/utils/show_shanckbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/app_text.dart';
import '../../utils/colors.dart';

class OrderDetails extends StatefulWidget {
  final String documentId;
  const OrderDetails({
    Key? key,
    required this.documentId,
  }) : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  final User user = FirebaseAuth.instance.currentUser!;

  late List<dynamic> productList;

  List<dynamic> productDetail = [];
  List<dynamic> userDetail = [];
  String date = "";
  String status = "";

  Future<void> getProductList() async {
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .doc(widget.documentId);

    await docRef.get().then((value) {
      date = value.data()!['date'];
      status = value.data()!['status'];
    });

    // print(date);

    final snapshot = await docRef.get();
    final data = snapshot.data() as Map<String, dynamic>;

    productList = List<dynamic>.from(data['products'] as List<dynamic>);
    getVendorOrderDetails();
  }

  // String productName = "";
  // String userName = "";
  // String address = "";

  void getVendorOrderDetails() async {
    Map<String, dynamic> product = {};
    Map<String, dynamic> user = {};
    for (int i = 0; i < productList.length; i++) {
      // print(productList[i]['pId']);
      await FirebaseFirestore.instance
          .collection('products')
          .doc(productList[i]['pId'])
          .get()
          .then((value) {
        product = {
          'ProductName': value.data()!['productName'],
          'image': value.data()!['images'][0],
          'quantity': productList[i]['quantity'],
          'price': productList[i]['price'],
        };
        productDetail.add(product);
        // product.clear();
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(productList[i]['userId'])
          .get()
          .then((value) {
        user = {
          'userName': value.data()!['name'],
          'address': value.data()!['address'],
        };
        userDetail.add(user);
      });
    }
    // print(userDetail);
    // print(productDetail);
    // getOrderTotal();
  }

  void productShipped() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .doc(widget.documentId)
        .update({
      'status': 'shipped',
    });
    Navigator.pop(context);
    showSnackBar(context, "Order Marked as Shipped!");
  }

  // @override
  // void initState() {
  //   super.initState();
  //   getProductList();
  // }

  double total = 0.0;
  // Add total price of the cart items
  void getOrderTotal() {
    double totall = 0.0;
    if (productList.isNotEmpty) {
      for (int i = 0; i < productList.length; i++) {
        int totalCartQuantity = 0;
        totalCartQuantity =
            totalCartQuantity + (productList[i]['quantity'] as int);

        totall = totall + (totalCartQuantity * productList[i]['price']);
      }
    }
    total = totall;
    print(total);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 45),
        child: FloatingActionButton(
          tooltip: "Refresh ",
          onPressed: () {
            setState(() {
              getProductList();
              getOrderTotal();
            });
          },
          backgroundColor: AppColors.primaryColor,
          child: const Icon(
            Icons.refresh,
            color: AppColors.secondaryColor,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: AppText(
            text: "Order Detail",
            color: AppColors.secondaryColor,
          ),
        ),
      ),
      body: Stack(
        children: [
          FutureBuilder<void>(
            future: getProductList(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.83,
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          child: AppText(
                            text: "Order ID: ${widget.documentId}",
                            color: AppColors.primaryColor,
                            weight: FontWeight.w500,
                            maxLines: 2,
                            size: 16,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                          ),
                          child: AppText(
                            text: "Order Date: $date",
                            color: AppColors.primaryColor,
                            size: 15,
                            weight: FontWeight.w500,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const AppText(
                                text: "Orders",
                                color: AppColors.primaryColor,
                                weight: FontWeight.w500,
                                size: 25,
                              ),
                              (status == "pending")
                                  ? AppText(
                                      text: "Status: $status",
                                      color: Colors.red,
                                      weight: FontWeight.bold,
                                      size: 16,
                                    )
                                  : AppText(
                                      text: "Status: $status",
                                      color: Colors.green,
                                      weight: FontWeight.bold,
                                      size: 16,
                                    ),
                            ],
                          ),
                        ),
                        (productList.isEmpty ||
                                productDetail.isEmpty ||
                                userDetail.isEmpty)
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: productList.length,
                                itemBuilder: (context, index) {
                                  final product = productDetail[index]
                                      as Map<String, dynamic>;
                                  final user =
                                      userDetail[index] as Map<String, dynamic>;
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      elevation: 4,
                                      child: ListTile(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        leading: Image.memory(
                                          base64Decode(product['image']),
                                          // height: 120,
                                          // width: 120,
                                          fit: BoxFit.cover,
                                        ),
                                        title: AppText(
                                          text: product['ProductName'],
                                          color: AppColors.primaryColor,
                                          size: 16,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                AppText(
                                                  text:
                                                      "Rs. ${product['price']}",
                                                  color:
                                                      AppColors.hintTextColor,
                                                  size: 15,
                                                ),
                                                AppText(
                                                  text:
                                                      "Qty: ${product['quantity']}",
                                                  color:
                                                      AppColors.hintTextColor,
                                                  size: 15,
                                                ),
                                              ],
                                            ),
                                            const Divider(
                                              color: AppColors.hintTextColor,
                                              thickness: 1,
                                            ),
                                            AppText(
                                              text:
                                                  "Deliver to: ${user['userName']}",
                                              color: AppColors.primaryColor,
                                              size: 16,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            AppText(
                                              text:
                                                  "Shipping Address: ${user['address']}",
                                              color: AppColors.hintTextColor,
                                              size: 15,
                                              maxLines: 4,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 55,
              width: MediaQuery.of(context).size.width,
              color: AppColors.primaryColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      child: Row(
                        children: [
                          const AppText(
                            text: "Total: ",
                            color: AppColors.secondaryColor,
                            size: 16,
                          ),
                          AppText(
                            text: "Rs. $total",
                            color: Colors.red,
                            size: 17,
                            weight: FontWeight.w600,
                          )
                        ],
                      ),
                    ),
                    (status == "pending")
                        ? AppButton(
                            onTap: () => productShipped(),
                            color: Colors.green,
                            height: 45,
                            radius: 10,
                            child: const AppText(
                              text: "Ship Product",
                              color: AppColors.secondaryColor,
                              weight: FontWeight.w500,
                              size: 14,
                            ),
                          )
                        : const AppText(
                            text: "Product(s) Shipped!",
                            color: AppColors.secondaryColor,
                            size: 15,
                          ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
