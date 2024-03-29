// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/logic/buyProduct.dart';
import 'package:ecommerce/utils/show_shanckbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

import '../../utils/app_button.dart';
import '../../utils/app_text.dart';
import '../../utils/app_textfield.dart';
import '../../utils/colors.dart';

class BuyNow extends StatefulWidget {
  final String image;
  final String name;
  final double price;
  final String id;
  final String vendorId;
  final int? quantity;
  const BuyNow({
    Key? key,
    required this.image,
    required this.name,
    required this.price,
    required this.id,
    required this.vendorId,
    this.quantity = 1,
  }) : super(key: key);

  @override
  State<BuyNow> createState() => _BuyNowState();
}

class _BuyNowState extends State<BuyNow> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController addressController = TextEditingController();
  final User user = FirebaseAuth.instance.currentUser!;
  final CollectionReference orders =
      FirebaseFirestore.instance.collection('orders');
  final BuyProduct buyProduct = BuyProduct();

  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String name = "";
  String paymentID = "";
  String contact = "";
  String email = "";

  bool inStock = false;

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

  void checkProductStock() async {
    await FirebaseFirestore.instance
        .collection('products')
        .doc(widget.id)
        .get()
        .then((value) async {
      if (value.data()!['quantity'] >= widget.quantity) {
        inStock = true;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    checkProductStock();
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
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: SizedBox(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                text: "Deliver to: $name",
                                color: AppColors.primaryColor,
                                weight: FontWeight.w500,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10)
                                        .copyWith(left: 4, bottom: 15),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.red),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 5),
                                    child: AppText(
                                      text: "Address",
                                      color: Colors.red,
                                      size: 15,
                                    ),
                                  ),
                                ),
                              ),
                              Form(
                                key: _formKey,
                                child: AppTextField(
                                  controller: addressController,
                                  hide: false,
                                  radius: 10,
                                  hintText:
                                      "Ex: MahendraPool, Pokhara, Gandaki Province",
                                  labelText: "Delivery Address",
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: AppText(
                                  text: contact,
                                  color: AppColors.hintTextColor,
                                  size: 15,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(bottom: 12),
                                child: Divider(
                                  color: AppColors.hintTextColor,
                                  thickness: 0.8,
                                ),
                              ),
                              SizedBox(
                                width: double.maxFinite,
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.email,
                                      color: AppColors.hintTextColor,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: AppText(
                                        text: email,
                                        color: AppColors.primaryColor,
                                        size: 15,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.2,
                        // color: Colors.amber,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  height: 100,
                                  width: 100,
                                  // color: Colors.red,
                                  child: Image.memory(
                                    base64Decode(
                                      widget.image,
                                    ),
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    height: 100,
                                    // color: Colors.green,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppText(
                                          text: widget.name,
                                          color: AppColors.primaryColor,
                                          size: 16,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            AppText(
                                              text: "Rs. ${widget.price}",
                                              color: AppColors.primaryColor,
                                              weight: FontWeight.bold,
                                              size: 15,
                                            ),
                                            const AppText(
                                              text: "Qty: 1",
                                              color: AppColors.hintTextColor,
                                              size: 12,
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Divider(
                                thickness: 1,
                                color: AppColors.hintTextColor,
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height:
                                  MediaQuery.of(context).size.height * 0.035,
                              // color: AppColors.primaryColor,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const AppText(
                                      text: "Subtotal: ",
                                      color: AppColors.primaryColor,
                                      size: 16,
                                    ),
                                    AppText(
                                      text: "Rs. ${widget.price}",
                                      color: Colors.red,
                                      weight: FontWeight.w500,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const AppText(
                                text: "Gross Total",
                                color: AppColors.primaryColor,
                                size: 16,
                              ),
                              AppText(
                                text: widget.price.toString(),
                                color: AppColors.primaryColor,
                                size: 15,
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const AppText(
                                  text: "Sercice Tax (1%)",
                                  color: AppColors.primaryColor,
                                  size: 15,
                                ),
                                AppText(
                                  text:
                                      (widget.price * 0.01).round().toString(),
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
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: Container(
              height: 65,
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
                                text:
                                    "Rs. ${widget.price + (widget.price * 0.01).round()}",
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
                        if (_formKey.currentState!.validate()) {
                          // placeOrder(reference: orders, context: context);

                          if (inStock) {
                            KhaltiScope.of(context).pay(
                              preferences: [
                                PaymentPreference.khalti,
                              ],
                              config: PaymentConfig(
                                amount: (widget.price +
                                            (widget.price * 0.01).round())
                                        .toInt() *
                                    100,
                                productIdentity: widget.id,
                                productName: widget.name,
                              ),
                              onSuccess: (PaymentSuccessModel success) {
                                showModalBottomSheet(
                                  barrierColor:
                                      AppColors.hintTextColor.withOpacity(0.5),
                                  elevation: 4,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(25),
                                      topRight: Radius.circular(25),
                                    ),
                                  ),
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      height: 300,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 15,
                                          horizontal: 8,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            const AppText(
                                              text: "🎉Payment Successful🎊",
                                              color: Colors.green,
                                              weight: FontWeight.bold,
                                              size: 25,
                                            ),
                                            AppButton(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              color: AppColors.primaryColor,
                                              height: 50,
                                              radius: 10,
                                              child: const AppText(
                                                text: "Got It",
                                                color: AppColors.secondaryColor,
                                                weight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                                paymentID = success.idx;
                                print(paymentID);
                                // placeOrder(reference: orders, context: context);
                                buyProduct.buyNow(
                                  reference: orders,
                                  context: context,
                                  serviceTax: widget.price,
                                  vendorId: widget.vendorId,
                                  pId: widget.id,
                                  pName: widget.name,
                                  quantity: widget.quantity!,
                                  price: widget.price,
                                  userId: user.uid,
                                  address: addressController.text,
                                  name: name,
                                  contact: contact,
                                  email: email,
                                  date: formattedDate,
                                  paymentId: paymentID,
                                );
                              },
                              onFailure: (PaymentFailureModel failure) {
                                showModalBottomSheet(
                                  barrierColor:
                                      AppColors.hintTextColor.withOpacity(0.5),
                                  elevation: 4,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(25),
                                      topRight: Radius.circular(25),
                                    ),
                                  ),
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      height: 300,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 15,
                                          horizontal: 8,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            AppText(
                                              text: failure.message,
                                              color: Colors.red,
                                            ),
                                            AppButton(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              color: AppColors.primaryColor,
                                              height: 50,
                                              radius: 10,
                                              child: const AppText(
                                                text: "Got It",
                                                color: AppColors.secondaryColor,
                                                weight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              onCancel: () {
                                showModalBottomSheet(
                                  barrierColor:
                                      AppColors.hintTextColor.withOpacity(0.5),
                                  elevation: 4,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(25),
                                      topRight: Radius.circular(25),
                                    ),
                                  ),
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Container(
                                      height: 300,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 15,
                                          horizontal: 8,
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            const AppText(
                                              text: "Payment Canceled",
                                              color: Colors.red,
                                              weight: FontWeight.bold,
                                            ),
                                            AppButton(
                                              onTap: () {
                                                Navigator.pop(context);
                                              },
                                              color: AppColors.primaryColor,
                                              height: 40,
                                              radius: 10,
                                              child: const AppText(
                                                text: "Got It",
                                                color: AppColors.secondaryColor,
                                                weight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          } else {
                            showSnackBar(context, "Product Out of Stock !");
                          }
                        }
                      },
                      color: AppColors.secondaryColor,
                      height: 45,
                      radius: 10,
                      child: const AppText(
                        text: "Place Order",
                        color: AppColors.primaryColor,
                        size: 15,
                        weight: FontWeight.w500,
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
