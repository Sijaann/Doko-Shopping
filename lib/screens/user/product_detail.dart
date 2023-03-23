import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/logic/updateData.dart';
import 'package:ecommerce/utils/app_button.dart';
import 'package:ecommerce/utils/app_text.dart';
import 'package:ecommerce/utils/colors.dart';
import 'package:ecommerce/utils/show_shanckbar.dart';
import 'package:flutter/material.dart';

class ProductDetail extends StatefulWidget {
  final List<dynamic> images;
  final String name;
  final String description;
  final double price;
  final String pId;
  final String uId;

  const ProductDetail({
    super.key,
    required this.images,
    required this.name,
    required this.description,
    required this.price,
    required this.pId,
    required this.uId,
  });

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  final UpdateData updateData = UpdateData();

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  // Future<void> addProductToCart({
  //   required List productDetailsList,
  // }) {
  //   return users
  //       .doc(widget.uId)
  //       .update({'cart': productDetailsList}).then((value) {
  //     showSnackBar(context, "Added to cart!");
  //   }).onError((error, stackTrace) {
  //     showSnackBar(context, error.toString());
  //   });
  // }

  // // Add Products to Cart
  // Future<void> addProductToCart({
  //   required Map<String, dynamic> productDetails,
  // }) {
  //   return users.doc(widget.uId).update({
  //     'cart': FieldValue.arrayUnion([productDetails])
  //   }).then((value) {
  //     showSnackBar(context, "Added to cart!");
  //   }).onError((error, stackTrace) {
  //     showSnackBar(context, error.toString());
  //   });
  // }

  // List productDetailsList = [];
  Map<String, dynamic> productDetails = {};
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: AppText(
            text: "Product Detail",
            color: AppColors.secondaryColor,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 65),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.35,
                      // color: Colors.red,
                      child: CarouselSlider(
                        items: widget.images
                            .map(
                              (e) => Builder(
                                builder: (BuildContext context) {
                                  return Image.memory(
                                    base64Decode(e),
                                    fit: BoxFit.fitHeight,
                                    height: MediaQuery.of(context).size.height *
                                        0.35,
                                  );
                                },
                              ),
                            )
                            .toList(),
                        options: CarouselOptions(
                          viewportFraction: 1,
                          height: MediaQuery.of(context).size.height * 0.35,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12)
                              .copyWith(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: AppText(
                                  text: widget.name,
                                  color: AppColors.primaryColor,
                                  size: 16,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: AppText(
                                  text: "Rs. ${widget.price}",
                                  color: AppColors.primaryColor,
                                  weight: FontWeight.w500,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Divider(
                                  thickness: 1,
                                  color: AppColors.hintTextColor,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Container(
                                  height: 50,
                                  width: double.maxFinite,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: AppColors.primaryColor,
                                  ),
                                  child: Row(
                                    children: const [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Icon(
                                          Icons.local_shipping_outlined,
                                          color: AppColors.secondaryColor,
                                        ),
                                      ),
                                      AppText(
                                        text: "Free Delivery",
                                        color: AppColors.secondaryColor,
                                        weight: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: Divider(
                                  thickness: 1,
                                  color: AppColors.hintTextColor,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: AppText(
                                  text: "Product Details",
                                  color: AppColors.primaryColor,
                                  weight: FontWeight.w500,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: AppText(
                                  text: widget.description,
                                  color: AppColors.hintTextColor,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
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
              height: 55,
              width: MediaQuery.of(context).size.width,
              color: AppColors.primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AppButton(
                    onTap: () {},
                    color: AppColors.primaryColor,
                    height: 50,
                    radius: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        AppText(
                          text: "Buy Now",
                          color: AppColors.secondaryColor,
                          size: 18,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Icon(
                          Icons.currency_rupee,
                          size: 20,
                          color: AppColors.secondaryColor,
                        ),
                      ],
                    ),
                  ),
                  const VerticalDivider(
                    thickness: 2,
                    color: AppColors.secondaryColor,
                  ),
                  AppButton(
                    onTap: () {
                      productDetails = {
                        'pId': widget.pId,
                        'name': widget.name,
                        'price': widget.price,
                        'quantity': quantity,
                        'images': widget.images,
                      };

                      setState(() {
                        // addProductToCart(productDetails: productDetails);
                        updateData.addProductToCart(
                          reference: users,
                          userId: widget.uId,
                          productDetails: productDetails,
                          context: context,
                        );

                        // addProductToCart(productDetailsList: [productDetails]);
                      });
                      productDetails.clear();
                    },
                    color: AppColors.primaryColor,
                    height: 50,
                    radius: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        AppText(
                          text: "Add To Cart",
                          color: AppColors.secondaryColor,
                          size: 18,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 20,
                          color: AppColors.secondaryColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
