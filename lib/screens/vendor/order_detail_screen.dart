import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/app_text.dart';
import '../../utils/colors.dart';

class OrderDetails extends StatefulWidget {
  final String documentId;
  const OrderDetails({
    super.key,
    required this.documentId,
  });

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  final User user = FirebaseAuth.instance.currentUser!;

  List productList = [];
  var prod;
  void getProductList() async {
    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('orders')
        .doc(widget.documentId);

    await docRef.get().then((DocumentSnapshot document) {
      final data = document.data() as Map<String, dynamic>;

      prod = data['products'] as List<dynamic>;

      for (var item in prod) {
        productList.add(item);
      }

      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    print(widget.documentId);
    getProductList();
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
            text: "Order Detail",
            color: AppColors.secondaryColor,
          ),
        ),
      ),
      body: productList == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SizedBox(
              height: MediaQuery.of(context).size.height * 0.95,
              width: MediaQuery.of(context).size.width,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: widget.documentId,
                        color: AppColors.primaryColor,
                      ),
                      AppText(
                        text: "Order Date",
                        color: AppColors.primaryColor,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(
                            text: "Orders",
                            color: AppColors.primaryColor,
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            child: const AppText(
                                text: "Shipped",
                                color: AppColors.secondaryColor),
                          )
                        ],
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: productList.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 2,
                            child: ListTile(
                              title: AppText(
                                text: productList[index]['pId'],
                                color: AppColors.primaryColor,
                              ),
                              subtitle: AppText(
                                text: productList[index]['price'].toString(),
                                color: AppColors.hintTextColor,
                                size: 15,
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
