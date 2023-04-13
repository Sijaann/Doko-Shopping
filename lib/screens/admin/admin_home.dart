import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/logic/logout.dart';
import 'package:ecommerce/screens/vendor/vendor_home.dart';
import 'package:ecommerce/utils/app_text.dart';
import 'package:ecommerce/utils/colors.dart';
import 'package:ecommerce/utils/show_shanckbar.dart';
import 'package:flutter/material.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  // Stream to get data from a collection
  final Stream<QuerySnapshot> userStream = FirebaseFirestore.instance
      .collection('users')
      .where('status', isEqualTo: 'verified')
      .where('userType', isEqualTo: 'Vendor')
      .snapshots();
  final SignOut signout = SignOut();

  CollectionReference vendorReference =
      FirebaseFirestore.instance.collection('users');

  CollectionReference productReference =
      FirebaseFirestore.instance.collection('products');

  Future<void> deleteVendor({
    required dynamic id,
    required CollectionReference vendorReference,
    required CollectionReference productReference,
    required BuildContext context,
  }) async {
    // Delete all subcollections of the vendor document
    final firestore = vendorReference.firestore;
    final vendorDocRef = vendorReference.doc(id);
    final collections = await firestore.collectionGroup(id).get();
    final batch = firestore.batch();
    collections.docs.forEach((doc) {
      batch.delete(doc.reference);
    });
    await batch.commit();

    // Delete the vendor document itself
    await vendorDocRef.delete();

    // Delete all products associated with the vendor
    final productQuerySnapshot =
        await productReference.where('vendorId', isEqualTo: id).get();
    final productBatch = productReference.firestore.batch();
    productQuerySnapshot.docs.forEach((doc) {
      productBatch.delete(doc.reference);
    });
    await productBatch.commit();
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
            text: "Admin",
            color: AppColors.secondaryColor,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: IconButton(
              onPressed: () {
                signout.logout(context: context);
              },
              icon: const Icon(Icons.logout_rounded),
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: userStream,
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

          final List<ListTile> listTiles = snapshot.data!.docs
              .map(
                (DocumentSnapshot document) => ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  title: AppText(
                    text: document['name'],
                    color: AppColors.primaryColor,
                    weight: FontWeight.w500,
                    size: 16,
                    maxLines: 2,
                  ),
                  subtitle: AppText(
                    text: document['email'] + ' | ' + document['contact'],
                    color: AppColors.hintTextColor,
                    size: 15,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    onPressed: () => deleteVendor(
                      id: document['userId'],
                      vendorReference: vendorReference,
                      productReference: productReference,
                      context: context,
                    ),
                    icon: const Icon(
                      Icons.delete,
                      size: 18,
                      color: Colors.red,
                    ),
                  ),
                ),
              )
              .toList();

          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 10).copyWith(top: 10),
            child: ListView.builder(
              itemCount: listTiles.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 2,
                    child: listTiles[index],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  // logout() {
  //   FirebaseAuth.instance.signOut().then(
  //         (value) => setState(
  //           () {
  //             Navigator.pushReplacement(context,
  //                 MaterialPageRoute(builder: (context) => const Login()));
  //           },
  //         ),
  //       );
  // }
}
