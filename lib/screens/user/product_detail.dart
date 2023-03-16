import 'package:ecommerce/utils/app_button.dart';
import 'package:ecommerce/utils/app_text.dart';
import 'package:ecommerce/utils/colors.dart';
import 'package:flutter/material.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
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
                      child: Image.network(
                        "https://images.unsplash.com/photo-1616423640778-28d1b53229bd?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80",
                        fit: BoxFit.cover,
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
                              const Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: AppText(
                                  text: "LUMIX Mirrorless Camera",
                                  color: AppColors.primaryColor,
                                  size: 16,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: AppText(
                                  text: "Rs. 50000",
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
                              const Padding(
                                padding: EdgeInsets.only(bottom: 10),
                                child: AppText(
                                  text:
                                      "Lorem Ipsum is simply dummy text of the printing and typesetting industry.  Lorem Ipsum has been the industry's  standard dummy text ever since the  1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                                  color: AppColors.hintTextColor,
                                  size: 15,
                                ),
                              ),
                              // const Padding(
                              //   padding: EdgeInsets.only(bottom: 10),
                              //   child: Divider(
                              //     thickness: 1,
                              //     color: AppColors.hintTextColor,
                              //   ),
                              // ),
                              // const Padding(
                              //   padding: EdgeInsets.only(bottom: 10),
                              //   child: AppText(
                              //     text:"Highlights",
                              //     color: AppColors.hintTextColor,
                              //     size: 15,
                              //   ),
                              // ),
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
            child: AppButton(
              onTap: () {},
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
          )
        ],
      ),
    );
  }
}
