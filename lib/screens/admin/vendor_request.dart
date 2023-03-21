import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/utils/app_text.dart';
import 'package:ecommerce/utils/colors.dart';
import 'package:ecommerce/utils/show_shanckbar.dart';
import 'package:flutter/material.dart';

class VendorRequest extends StatefulWidget {
  const VendorRequest({super.key});

  @override
  State<VendorRequest> createState() => _VendorRequestState();
}

class _VendorRequestState extends State<VendorRequest> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  // Update the vendor status with to the UserID of the vendor
  Future<void> updateRequest({required dynamic id}) {
    return users.doc(id).update({'status': "verified"}).then((value) {
      showSnackBar(context, "Vendor Account Verified");
    }).catchError((error) {
      showSnackBar(context, error.toString());
    });
  }

  // This Delete only delets the Record of the vendor not the account itself.
  Future<void> deleteRequest({required dynamic id}) {
    return users.doc(id).delete().then((value) {
      showSnackBar(context, "Request Removed!");
    }).catchError((error) {
      showSnackBar(context, error.toString());
    });
  }

  final Stream<QuerySnapshot> userStream = FirebaseFirestore.instance
      .collection('users')
      .where('status', isEqualTo: 'unverified')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    // getUnverifiedUsers();
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: AppText(
            text: "Pending Requests",
            color: AppColors.secondaryColor,
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('status', isEqualTo: 'unverified')
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

          final List<ListTile> listTiles = snapshot.data!.docs
              .map(
                (DocumentSnapshot document) => ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  title: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: AppText(
                      text: document['name'],
                      color: AppColors.primaryColor,
                      weight: FontWeight.w500,
                      size: 16,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: AppText(
                      text: document['email'] + ' | ' + document['contact'],
                      color: AppColors.hintTextColor,
                      size: 15,
                    ),
                  ),
                  trailing: SizedBox(
                    width: 65,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              updateRequest(id: document['userId']);
                            });
                          },
                          child: const Icon(
                            Icons.check,
                            color: Colors.green,
                            size: 18,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              deleteRequest(id: document['userId']);
                            });
                          },
                          child: const Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 18,
                          ),
                        )
                      ],
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
}
