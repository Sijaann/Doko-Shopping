import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce/utils/app_button.dart';
import 'package:ecommerce/utils/app_text.dart';
import 'package:ecommerce/utils/app_textfield.dart';
import 'package:ecommerce/utils/colors.dart';
import 'package:ecommerce/utils/pickImages.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  List<String> categories = [
    "Mobile",
    "Laptop",
    "Appliances",
    "Clothing",
    "Cosmetics",
  ];

  String categoryValue = "Mobile";

  List<File> images = [];

  void selectImage() async {
    var res = await pickImage();
    setState(() {
      images = res!;
    });
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
            text: "Add Products",
            color: AppColors.secondaryColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Column(
            children: [
              (images.isNotEmpty)
                  ? CarouselSlider(
                      items: images
                          .map(
                            (e) => Builder(
                              builder: (BuildContext context) {
                                return Image.file(
                                  e,
                                  fit: BoxFit.cover,
                                  height: 250,
                                );
                              },
                            ),
                          )
                          .toList(),
                      options: CarouselOptions(
                        viewportFraction: 1,
                        height: 200,
                      ),
                    )
                  : GestureDetector(
                      onTap: selectImage,
                      child: Container(
                        height: 250,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 2,
                            color: AppColors.primaryColor,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.image,
                                color: AppColors.hintTextColor,
                                size: 35,
                              ),
                              AppText(
                                text: "Select Images",
                                color: AppColors.hintTextColor,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: AppTextField(
                        controller: _productNameController,
                        hide: false,
                        radius: 15,
                        hintText: "Product Name",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: AppTextField(
                        controller: _descriptionController,
                        hide: false,
                        radius: 15,
                        hintText: "Description",
                        maxLines: 7,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: AppTextField(
                        controller: _priceController,
                        hide: false,
                        radius: 15,
                        hintText: "Price",
                        type: TextInputType.number,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: AppTextField(
                        controller: _quantityController,
                        hide: false,
                        radius: 15,
                        hintText: "Quantity",
                        type: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10)
                    .copyWith(top: 10),
                child: DropdownButton(
                  borderRadius: BorderRadius.circular(10),
                  isExpanded: true,
                  value: categoryValue,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: categories.map((String item) {
                    return DropdownMenuItem(
                      value: item,
                      child: AppText(
                        text: item,
                        color: AppColors.primaryColor,
                      ),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    setState(() {
                      categoryValue = value!;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: AppButton(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {}
                    },
                    color: AppColors.primaryColor,
                    height: 50,
                    radius: 15,
                    child: const AppText(
                      text: "Add Product",
                      color: AppColors.secondaryColor,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
