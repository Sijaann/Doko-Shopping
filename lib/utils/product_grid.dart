import 'dart:convert';

import 'package:ecommerce/utils/app_text.dart';
import 'package:ecommerce/utils/colors.dart';
import 'package:flutter/material.dart';

class ProductGrid extends StatelessWidget {
  final String imageString;
  final String name;
  final double price;
  final double height;
  const ProductGrid(
      {super.key,
      required this.imageString,
      required this.name,
      required this.price,
      required this.height});

  @override
  Widget build(BuildContext context) {
    return Card(
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
              height: MediaQuery.of(context).size.height * 0.143,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                child: Image.memory(
                  base64Decode(
                    imageString,
                  ),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Container(
              width: double.maxFinite,
              height: height,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
                color: AppColors.primaryColor,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4).copyWith(left: 7),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      text: name,
                      color: AppColors.secondaryColor,
                      size: 16,
                      weight: FontWeight.w500,
                      overflow: TextOverflow.ellipsis,
                    ),
                    AppText(
                      text: "Rs.${price}",
                      color: AppColors.secondaryColor,
                      size: 13,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
