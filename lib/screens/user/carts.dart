import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/screens/user/check_out_screen.dart';
import 'package:ecommerce/utils/app_button.dart';
import 'package:ecommerce/utils/app_text.dart';
import 'package:ecommerce/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final User user = FirebaseAuth.instance.currentUser!;

  CollectionReference userReference =
      FirebaseFirestore.instance.collection('users');

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List cartList = [];
  var cart;

  // Get Items from cart field
  void getCartItems() {
    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

    docRef.get().then((DocumentSnapshot document) {
      final data = document.data() as Map<String, dynamic>;

      cart = data['cart'] as List<dynamic>;

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

  double total = 0.0;
  // Add total price of the cart items
  void getTotalCartPrice() {
    if (cartList.isNotEmpty) {
      for (int i = 0; i < cartList.length; i++) {
        int totalCartQuantity = 0;
        totalCartQuantity =
            totalCartQuantity + (cartList[i]['quantity'] as int);

        total = total + (totalCartQuantity * cartList[i]['price']);
        // setState(() {});
      }
    }
  }

  Future<void> _incrementProductQuantity(int index) async {
    final userRef = _firestore.collection('users').doc(user.uid);
    // print(userRef);

    // Use a transaction to update the quantity of the product in the cart
    await _firestore.runTransaction((transaction) async {
      final userDoc = await transaction.get(userRef);
      final List<dynamic> cart = userDoc.data()?['cart'] ?? [];
      final int newQuantity = cart[index]['quantity'] + 1;
      cart[index]['quantity'] = newQuantity;
      transaction.update(userRef, {'cart': cart});
    });
  }

  Future<void> _decreaseProductQuantity(int index) async {
    final userRef = _firestore.collection('users').doc(user.uid);

    // Use a transaction to update the quantity of the product in the cart
    await _firestore.runTransaction((transaction) async {
      final userDoc = await transaction.get(userRef);
      final List<dynamic> cart = userDoc.data()?['cart'] ?? [];
      final int newQuantity = cart[index]['quantity'] - 1;
      cart[index]['quantity'] = newQuantity;
      transaction.update(userRef, {'cart': cart});
    });
  }

  Future<void> _deleteCartItem(int index) async {
    final userRef = _firestore.collection('users').doc(user.uid);
    await userRef.update({
      'cart': FieldValue.arrayRemove([cartList[index]])
    });
  }

  @override
  void initState() {
    super.initState();

    getCartItems();
  }

  @override
  Widget build(BuildContext context) {
    // getCartItems();
    // getTotalCartPrice();
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: AppText(
            text: "Cart",
            color: AppColors.secondaryColor,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('userId', isEqualTo: user.uid)
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

          return (cartList.isEmpty)
              ? const Center(
                  child: AppText(
                    text: "No items in cart",
                    color: AppColors.primaryColor,
                  ),
                )
              : (cart == null)
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(10),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.62,
                              child: ListView.builder(
                                itemCount: cartList.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 4,
                                    child: ListTile(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      leading: Image.memory(
                                        base64Decode(
                                          cartList[index]['images'],
                                        ),
                                      ),
                                      title: AppText(
                                        text: cartList[index]['name'],
                                        color: AppColors.primaryColor,
                                        size: 16,
                                      ),
                                      subtitle: AppText(
                                        text: "Rs. ${cartList[index]['price']}",
                                        color: AppColors.hintTextColor,
                                        size: 15,
                                      ),
                                      trailing: SizedBox(
                                        width: 70,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                if (cartList[index]
                                                        ['quantity'] >
                                                    1) {
                                                  await _decreaseProductQuantity(
                                                      index);
                                                  setState(() {
                                                    cartList[index]
                                                        ['quantity'] -= 1;
                                                    cartList.clear();
                                                    total = 0.0;
                                                    getCartItems();
                                                  });
                                                }
                                                if (cartList[index]
                                                        ['quantity'] <=
                                                    1) {
                                                  setState(() {
                                                    _deleteCartItem(index);
                                                    cartList.clear();
                                                    total = 0.0;
                                                    getCartItems();
                                                  });
                                                }
                                              },
                                              child: const Icon(
                                                Icons
                                                    .remove_circle_outline_outlined,
                                                size: 18,
                                              ),
                                            ),
                                            AppText(
                                              text:
                                                  "${cartList[index]['quantity']}",
                                              color: AppColors.primaryColor,
                                              size: 18,
                                            ),
                                            GestureDetector(
                                              onTap: () async {
                                                await _incrementProductQuantity(
                                                    index);
                                                setState(() {
                                                  cartList[index]['quantity'] +=
                                                      1;
                                                  cartList.clear();
                                                  total = 0.0;
                                                  getCartItems();
                                                });
                                              },
                                              child: const Icon(
                                                Icons
                                                    .add_circle_outline_rounded,
                                                size: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 5),
                              child: Divider(
                                thickness: 2,
                                color: AppColors.hintTextColor,
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              height: 55,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const AppText(
                                    text: "Total",
                                    color: AppColors.secondaryColor,
                                    size: 16,
                                  ),
                                  const VerticalDivider(
                                    // height: ,
                                    thickness: 2,
                                    color: AppColors.secondaryColor,
                                  ),
                                  AppText(
                                    text: "Rs. $total",
                                    color: AppColors.secondaryColor,
                                    size: 16,
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: AppButton(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Checkout(),
                                    ),
                                  );
                                },
                                color: AppColors.primaryColor,
                                height: 50,
                                radius: 15,
                                child: const AppText(
                                  text: "Proceed to check out",
                                  color: AppColors.secondaryColor,
                                  size: 15,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
        },
      ),
    );
  }
}
