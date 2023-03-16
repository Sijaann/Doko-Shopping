import 'package:ecommerce/utils/app_button.dart';
import 'package:ecommerce/utils/app_text.dart';
import 'package:ecommerce/utils/colors.dart';
import 'package:flutter/material.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  int count = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: AppText(
              text: "Cart",
              color: AppColors.secondaryColor,
            ),
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.62,
                      child: ListView.builder(
                        itemCount: 20,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 4,
                            child: ListTile(
                              leading: Image.network(
                                "https://images.unsplash.com/photo-1616423640778-28d1b53229bd?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80",
                                // fit: BoxFit.fitHeight,
                              ),
                              title: const Text(
                                "LUMIX Mirrorless Camera",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w500,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              subtitle: const AppText(
                                text: "Rs. 50000",
                                color: AppColors.hintTextColor,
                                size: 15,
                              ),
                              trailing: SizedBox(
                                width: 70,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          count--;
                                        });
                                      },
                                      child: const Icon(
                                        Icons.remove_circle_outline_outlined,
                                        size: 18,
                                      ),
                                    ),
                                    AppText(
                                      text: count.toString(),
                                      color: AppColors.primaryColor,
                                      size: 18,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          count++;
                                        });
                                      },
                                      child: const Icon(
                                        Icons.add_circle_outline_rounded,
                                        size: 18,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: Divider(
                        thickness: 2,
                        color: AppColors.hintTextColor,
                      ),
                    ),
                    Container(
                      width: 250,
                      height: 55,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: const [
                          AppText(
                            text: "Total",
                            color: AppColors.secondaryColor,
                            size: 16,
                          ),
                          VerticalDivider(
                            // height: ,
                            thickness: 2,
                            color: AppColors.secondaryColor,
                          ),
                          AppText(
                            text: "Rs.50000",
                            color: AppColors.secondaryColor,
                            size: 16,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: AppButton(
                        onTap: () {},
                        color: AppColors.primaryColor,
                        height: 50,
                        radius: 15,
                        child: const AppText(
                          text: "Proceed to check out",
                          color: AppColors.secondaryColor,
                          size: 15,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
