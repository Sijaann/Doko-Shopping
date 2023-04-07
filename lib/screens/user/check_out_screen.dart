import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/utils/app_button.dart';
import 'package:ecommerce/utils/app_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

import '../../utils/app_text.dart';
import '../../utils/colors.dart';
import '../../utils/show_shanckbar.dart';

class Checkout extends StatefulWidget {
  const Checkout({super.key});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  final TextEditingController addressController = TextEditingController();

  final User user = FirebaseAuth.instance.currentUser!;

  final CollectionReference orders =
      FirebaseFirestore.instance.collection('orders');

  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  final _formKey = GlobalKey<FormState>();
  String paymentID = "";

  String name = "";
  String contact = "";
  String email = "";

  List cartList = [];

  double total = 0.0;

  String productId = "";
  String productName = "";

  void getUserData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get()
        .then((value) {
      setState(() {
        name = value.data()!['name'];
        email = value.data()!['email'];
        contact = value.data()!['contact'];
        addressController.text = value.data()!['address'];
      });
    });
  }

// Get Items from cart field
  void getCartItems() {
    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

    docRef.get().then((DocumentSnapshot document) {
      final data = document.data() as Map<String, dynamic>;

      final cart = data['cart'] as List<dynamic>;

      for (var item in cart) {
        cartList.add(item);
      }

      setState(() {
        getTotalCartPrice();
      });
    }).onError((error, stackTrace) {
      // showSnackBar(context, error.toString());
      debugPrint(error.toString());
    });
  }

  // Add total price of the cart items
  void getTotalCartPrice() {
    if (cartList.isNotEmpty) {
      for (int i = 0; i < cartList.length; i++) {
        int totalCartQuantity = 0;
        totalCartQuantity =
            totalCartQuantity + (cartList[i]['quantity'] as int);

        total = total + (totalCartQuantity * cartList[i]['price']);
      }
    }
  }

  void checkOrderQuantity(String productIdentity, String productName) async {
    int count = 0;
    for (int i = 0; i < cartList.length; i++) {
      await FirebaseFirestore.instance
          .collection("products")
          .doc(cartList[i]['pId'])
          .get()
          .then((value) async {
        if (value.data()!['quantity'] >= cartList[i]['quantity']) {
          count++;

          if (count == cartList.length) {
            KhaltiScope.of(context).pay(
              preferences: [
                PaymentPreference.khalti,
              ],
              config: PaymentConfig(
                amount: (total + (total * 0.01).round()).toInt() * 100,
                productIdentity: productIdentity,
                productName: productName,
              ),
              onSuccess: (PaymentSuccessModel success) async {
                showSnackBar(context, "Payment Successful !");
                paymentID = success.idx;
                print(paymentID);

                for (int i = 0; i < cartList.length; i++) {
                  await FirebaseFirestore.instance
                      .collection('products')
                      .doc(cartList[i]['pId'])
                      .update({
                    'quantity':
                        value.data()!['quantity'] - cartList[i]['quantity']
                  });
                }

                placeOrder(reference: orders, context: context);

                // checkOrderQuantity();
              },
              onFailure: (PaymentFailureModel failure) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: AppText(
                        text: failure.message,
                        color: Colors.red,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {},
                          child: const AppText(
                            text: "OK",
                            color: AppColors.primaryColor,
                            weight: FontWeight.w500,
                          ),
                        )
                      ],
                    );
                  },
                );
              },
              onCancel: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const AppText(
                        text: "Payment Canceled!",
                        color: Colors.red,
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const AppText(
                            text: "OK",
                            color: AppColors.primaryColor,
                            weight: FontWeight.w500,
                          ),
                        )
                      ],
                    );
                  },
                );
              },
            );
            // for (int i = 0; i < cartList.length; i++) {
            //   await FirebaseFirestore.instance
            //       .collection("products")
            //       .doc(cartList[i]['pId'])
            //       .update({
            //     'quantity': value.data()!['quantity'] - cartList[i]['quantity'],
            //   });
            // }
          }
          // placeOrder(
          //   reference: orders,
          //   context: context,
          // );
        } else {
          showSnackBar(context,
              "${value.data()!['productName']} quantity exceeds stock quantity!");
          // throw ("Request Quantity Exceeded!");
        }
      });
    }
  }

  Future<void> placeOrder({
    required CollectionReference reference,
    required BuildContext context,
  }) async {
    try {
      /**
       * vendorProducts={
       * "vendorId": [
       *    {"pId:": id, 'quantity': quantity, ..}, 
       *    {"pId:": id, 'quantity': quantity, ..},
       *   ]
       * }
       */

      final vendorProducts = <String, List<Map<String, dynamic>>>{};
      for (final cartItem in cartList) {
        final vendorId = cartItem['vendor'];
        vendorProducts.putIfAbsent(vendorId, () => []);

        // Adds cart Items of respective cendor to the List
        vendorProducts[vendorId]!.add(cartItem);
      }

      await reference.add({
        'serviceTax': (total * 0.01).ceilToDouble(),
        'products': [],
        'userId': user.uid,
        'grandTotal': total + (total * 0.02).ceilToDouble(),
        'address': addressController.text,
        'name': name,
        'contact': contact,
        'email': email,
        'date': formattedDate,
        'paymentID': paymentID,
        'productRandId': productId,
        'productRandName': productName,
      }).then((value) async {
        for (final vendorId in vendorProducts.keys) {
          final vendorOrderRef = FirebaseFirestore.instance
              .collection('users')
              .doc(vendorId)
              .collection('orders')
              .doc(value.id);

          final vendorOrderDetails = vendorProducts[vendorId]!
              .map((cartItem) => {
                    'pId': cartItem['pId'],
                    'quantity': cartItem['quantity'],
                    'price': cartItem['price'],
                    'userId': user.uid,
                  })
              .toList();

          await vendorOrderRef.set({
            'date': formattedDate,
            'paymentId': paymentID,
            'productRandId': productId,
            'productRandName': productName,
            'status': "pending",
          }).then((value) async {
            await vendorOrderRef.update({
              'products': FieldValue.arrayUnion(vendorOrderDetails),
            }).onError((error, stackTrace) {
              debugPrint(error.toString());
            });
          });
        }

        final allOrderDetails = cartList
            .map((cartItem) => {
                  'pId': cartItem['pId'],
                  'name': cartItem['name'],
                  'quantity': cartItem['quantity'],
                  'price': cartItem['price'],
                  'vendor': cartItem['vendor'],
                })
            .toList();

        await reference.doc(value.id).update({
          'products': FieldValue.arrayUnion(allOrderDetails),
        }).then((value) async {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({'cart': FieldValue.arrayRemove(cartList)});
        }).onError((error, stackTrace) {
          debugPrint(error.toString());
        });

        // for (int i = 0; i < cartList.length; i++) {
        //   await FirebaseFirestore.instance
        //       .collection("products")
        //       .doc(cartList[i]['pId'])
        //       .get()
        //       .then((value) async {
        //     await FirebaseFirestore.instance
        //         .collection('products')
        //         .doc(cartList[i]['pId'])
        //         .update({
        //       'quantity': value.data()!['quantity'] - cartList[i]['quantity']
        //     });
        //   });
        // }
      });

      Navigator.pop(context);
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(
        Iterable.generate(
          length,
          (_) => _chars.codeUnitAt(
            _rnd.nextInt(_chars.length),
          ),
        ),
      );

  @override
  void initState() {
    super.initState();
    getUserData();
    getCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: AppText(
            text: "Check Out",
            color: AppColors.secondaryColor,
          ),
        ),
      ),
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.83,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  children: [
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text: "Deliver to: $name",
                              color: AppColors.primaryColor,
                              weight: FontWeight.w500,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.red,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(4.0),
                                  child: AppText(
                                    text: "Address",
                                    color: Colors.red,
                                    size: 17,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Form(
                                key: _formKey,
                                child: AppTextField(
                                  controller: addressController,
                                  hide: false,
                                  radius: 10,
                                  hintText: "Ex: Nadipur, Pokhara",
                                  labelText: "Delivery Address",
                                ),
                              ),
                            ),
                            AppText(
                              text: contact,
                              color: AppColors.hintTextColor,
                              size: 18,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Divider(
                                thickness: 1,
                                color: AppColors.hintTextColor,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.email,
                                  color: AppColors.hintTextColor,
                                  // size: 17,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: AppText(
                                    text: email,
                                    color: AppColors.hintTextColor,
                                    size: 15,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: AppText(
                          text: "Your Order",
                          color: AppColors.hintTextColor,
                          weight: FontWeight.w500,
                        ),
                      ),
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: cartList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: 150,
                                  width: MediaQuery.of(context).size.width,
                                  // color: Colors.amber,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Image.memory(
                                        base64Decode(
                                          cartList[index]['images'],
                                        ),
                                        fit: BoxFit.cover,
                                        height: 120,
                                        width: 120,
                                      ),
                                      SizedBox(
                                        height: 120,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.6,
                                        // color: Colors.blue,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            AppText(
                                              text: cartList[index]['name'],
                                              color: AppColors.primaryColor,
                                              size: 16,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                AppText(
                                                  text:
                                                      "Rs. ${cartList[index]['price']}",
                                                  color: AppColors.primaryColor,
                                                  weight: FontWeight.bold,
                                                  size: 16,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 20),
                                                  child: AppText(
                                                    text:
                                                        "Qty: ${cartList[index]['quantity']}",
                                                    color:
                                                        AppColors.hintTextColor,
                                                    weight: FontWeight.w500,
                                                    size: 16,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  child: Divider(
                                    thickness: 1,
                                    color: AppColors.hintTextColor,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 15)
                                          .copyWith(bottom: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const AppText(
                                        text: "Subtotal: ",
                                        color: AppColors.primaryColor,
                                        size: 17,
                                      ),
                                      AppText(
                                        text:
                                            "Rs. ${cartList[index]['quantity'] * cartList[index]['price']}",
                                        color: Colors.red,
                                        size: 18,
                                        weight: FontWeight.w500,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: AppText(
                                text: "Order Summary",
                                color: AppColors.primaryColor,
                                weight: FontWeight.w500,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const AppText(
                                  text: "Gross Total",
                                  color: AppColors.primaryColor,
                                  size: 16,
                                ),
                                AppText(
                                  text: total.toString(),
                                  color: AppColors.primaryColor,
                                  size: 15,
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const AppText(
                                    text: "Sercice Tax (1%)",
                                    color: AppColors.primaryColor,
                                    size: 15,
                                  ),
                                  AppText(
                                    text: (total * 0.01).round().toString(),
                                    color: AppColors.primaryColor,
                                    size: 15,
                                  ),
                                ],
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              const AppText(
                                text: "Total: ",
                                color: AppColors.secondaryColor,
                                size: 16,
                              ),
                              AppText(
                                text: "Rs. ${total + (total * 0.01).round()}",
                                color: Colors.red,
                                size: 17,
                                weight: FontWeight.w600,
                              )
                            ],
                          ),
                          const AppText(
                            text: "All taxex included",
                            color: AppColors.hintTextColor,
                            size: 12,
                          )
                        ],
                      ),
                    ),
                    AppButton(
                      onTap: () {
                        // String totall = total.toString();
                        // print(total.toInt().runtimeType);
                        productId = getRandomString(20);

                        productName = getRandomString(15);

                        if (_formKey.currentState!.validate()) {
                          checkOrderQuantity(productId, productName);
                        }
                      },
                      color: AppColors.secondaryColor,
                      height: 45,
                      radius: 10,
                      child: const AppText(
                        text: "Place Order",
                        color: AppColors.primaryColor,
                        weight: FontWeight.w500,
                        size: 14,
                      ),
                    )
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
