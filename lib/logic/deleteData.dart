import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../utils/show_shanckbar.dart';

class DeleteData {
  /**
   * Deletes Vendor Verification Request form firestore.
   * This Delete only delets the Record of the vendor not the account itself.
   */
  Future<void> deleteRequest({
    required dynamic id,
    required CollectionReference reference,
    required BuildContext context,
  }) {
    return reference.doc(id).delete().then((value) {
      showSnackBar(context, "Request Removed!");
    }).catchError((error) {
      showSnackBar(context, error.toString());
    });
  }

  /**
   * Delete Product from firebase firestore
   */
  Future<void> deleteProduct(
      {required dynamic id,
      required CollectionReference reference,
      required BuildContext context}) {
    return reference.doc(id).delete().then((value) {
      showSnackBar(context, "Product Deleted!");
    }).catchError((error) {
      showSnackBar(context, error.toString());
    });
  }
}
