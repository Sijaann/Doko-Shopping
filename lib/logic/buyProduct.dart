import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/utils/show_shanckbar.dart';
import 'package:flutter/material.dart';

class BuyProduct {
  Future<void> buyNow({
    required CollectionReference reference,
    required BuildContext context,
    required double serviceTax,
    required String vendorId,
    required String pId,
    required String pName,
    required int quantity,
    required double price,
    required dynamic userId,
    required String address,
    required String name,
    required String contact,
    required String email,
    required String date,
    required String paymentId,
  }) async {
    try {
      await reference.add({
        'serviceTax': price * 0.01.ceilToDouble(),
        'vendorId': vendorId,
        'products': [
          {
            'pId': pId,
            'pName': pName,
            'quantity': quantity,
            'price': price,
            'total': quantity * price
          }
        ],
        'userId': userId,
        'grandTotal': price + (price * 0.01).ceilToDouble(),
        'address': address,
        'name': name,
        'contact': contact,
        'email': email,
        'date': date,
        'paymentId': paymentId,
      }).then((value) async {
        Map<String, dynamic> vendorOrderDetails = {
          'pId': pId,
          'quantity': quantity,
          'price': price,
          'userId': userId,
        };
        // print(vendorOrderDetails);

        final vendorOrderRef = FirebaseFirestore.instance
            .collection('users')
            .doc(vendorId)
            .collection('orders')
            .doc(value.id);

        await vendorOrderRef.set({
          'date': date,
          'paymentId': paymentId,
          'status': "pending",
        }).then((value) async {
          await vendorOrderRef.update({
            'products': FieldValue.arrayUnion([vendorOrderDetails]),
          }).onError((error, stackTrace) {
            debugPrint(error.toString());
          });
        }).onError((error, stackTrace) {
          debugPrint(error.toString());
        });

        Navigator.pop(context);
        showSnackBar(context, "Order Placed Successfully!");
      }).then((value) async {
        await FirebaseFirestore.instance
            .collection('products')
            .doc(pId)
            .get()
            .then((value) async {
          await FirebaseFirestore.instance
              .collection('products')
              .doc(pId)
              .update({
            'quantity': value.data()!['quantity'] - quantity,
          });
        });
      });
    } catch (error) {
      debugPrint(error.toString());
    }
  }
}
