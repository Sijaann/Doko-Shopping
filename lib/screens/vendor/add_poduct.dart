import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/utils/app_button.dart';
import '/utils/app_text.dart';
import '/utils/app_textfield.dart';
import '/utils/colors.dart';
import '/utils/pickImages.dart';
import '/utils/show_shanckbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = GlobalKey<FormState>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
    "Electronics",
  ];

  String categoryValue = "Mobile";

  List<File> images = [];

  void selectImage() async {
    var res = await pickImage();
    setState(() {
      images = res!;
    });

    // print(images);
    openImage();
  }

  // String imagePath = "";
  List<String> imagePaths = [];
  List<File> imageFiles = [];
  List<Uint8List> imageBytes = [];
  List<String> base64Strings = [];

  openImage() async {
    try {
      for (int i = 0; i < images.length; i++) {
        imagePaths.add(images[i].toString().substring(6));
        // print(i);
      }
      // print(imagePaths);

      for (String path in imagePaths) {
        int pathLength = path.length;
        imageFiles.add(
          File(
            path.substring(2, pathLength - 1),
          ),
        );
        // print(imageFiles);
      }

      for (File file in imageFiles) {
        // Uint8List imgByte = await file.readAsBytes();
        imageBytes.add(await file.readAsBytes());
      }
      // print(imageBytes);

      for (Uint8List imgByte in imageBytes) {
        base64Strings.add(base64Encode(imgByte));
      }
      // debugPrint(base64Strings[0]);
    } catch (e) {
      print(e.toString());
    }
  }

  // void _addProducts() async {
  //   try {
  //     final User user = FirebaseAuth.instance.currentUser!;
  //     String vendorId = user.uid;
  //     String productName = _productNameController.text;
  //     String description = _descriptionController.text;
  //     double price = double.parse(_priceController.text);
  //     int quantity = int.parse(_quantityController.text);
  //     String category = categoryValue;
  //     List images = base64Strings;

  //     await _firestore.collection('products').doc().set({
  //       'vendorId': vendorId,
  //       'productName': productName,
  //       'description': description,
  //       'price': price,
  //       'quantity': quantity,
  //       'category': category,
  //       'images': images,
  //     }).then((value) {
  //       showSnackBar(context, "Product added successfully");

  //       Navigator.pop(context);
  //     }).onError((error, stackTrace) {
  //       showSnackBar(context, error.toString());
  //     });
  //   } catch (e) {
  //     showSnackBar(context, e.toString());
  //   }
  // }

  void _addProducts() async {
    try {
      final User user = FirebaseAuth.instance.currentUser!;
      String vendorId = user.uid;
      String productName = _productNameController.text;
      String description = _descriptionController.text;
      double price = double.parse(_priceController.text);
      int quantity = int.parse(_quantityController.text);
      String category = categoryValue;
      List images = base64Strings;

      DocumentReference newProductRef =
          await _firestore.collection('products').add({
        'vendorId': vendorId,
        'productName': productName,
        'description': description,
        'price': price,
        'quantity': quantity,
        'category': category,
        'images': images,
      });

      String newProductId = newProductRef.id;
      await newProductRef.update({'productId': newProductId}).then((value) {
        showSnackBar(context, "Product added successfully");
        Navigator.pop(context);
      });
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _addProducts();
  // }

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
                            // crossAxisAlignment: CrossAxisAlignment.center,
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
                              ),
                              AppText(
                                text:
                                    "( Choose landscape image for better presentation )",
                                color: AppColors.hintTextColor,
                                size: 14,
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
                      if (_formKey.currentState!.validate()) {
                        if (images.isNotEmpty) {
                          _addProducts();
                        } else {
                          showSnackBar(
                              context, "Please Select atleast one image");
                        }
                      }
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
