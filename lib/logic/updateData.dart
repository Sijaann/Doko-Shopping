import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../utils/show_shanckbar.dart';

class UpdateData {
  // Update the vendor verification status
  Future<void> updateVendorRequest(
      {required dynamic id,
      required CollectionReference reference,
      required BuildContext context}) {
    return reference.doc(id).update({'status': "verified"}).then((value) {
      showSnackBar(context, "Vendor Account Verified");
    }).catchError((error) {
      showSnackBar(context, error.toString());
    });
  }

  // Update Product Details
  Future<void> updateProduct({
    required dynamic id,
    required CollectionReference reference,
    required BuildContext context,
    required String productName,
    required String description,
    required double price,
    required int quantity,
    required String category,
    required List<String> images,
    List? unchangedImages,
  }) {
    if (images.isEmpty) {
      return reference.doc(id).update({
        'productName': productName,
        'description': description,
        'price': price.toDouble(),
        'quantity': quantity.toInt(),
        'category': category,
        'images': unchangedImages,
      }).then((value) {
        Navigator.pop(context);
        showSnackBar(context, "Product Updated!");
      });
    } else {
      return reference.doc(id).update({
        'productName': productName,
        'description': description,
        'price': price.toDouble(),
        'quantity': quantity.toInt(),
        'category': category,
        'images': images,
      }).then((value) {
        Navigator.pop(context);
        showSnackBar(context, "Product Updated!");
      });
    }
  }

  // Add Products to Cart
  Future<void> addProductToCart(
      {required CollectionReference reference,
      required dynamic userId,
      required Map<String, dynamic> productDetails,
      required BuildContext context}) {
    return reference.doc(userId).update({
      'cart': FieldValue.arrayUnion([productDetails])
    }).then((value) {
      showSnackBar(context, "Added to cart!");
    }).onError((error, stackTrace) {
      showSnackBar(context, error.toString());
    });
  }
}
