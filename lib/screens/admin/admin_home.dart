import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/logic/logout.dart';
import 'package:ecommerce/utils/app_text.dart';
import 'package:ecommerce/utils/colors.dart';
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
                  ),
                  subtitle: AppText(
                    text: document['email'] + ' | ' + document['contact'],
                    color: AppColors.hintTextColor,
                    size: 15,
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
