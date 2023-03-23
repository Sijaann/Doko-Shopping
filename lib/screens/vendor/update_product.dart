import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/logic/updateData.dart';
import 'package:flutter/material.dart';

import '../../utils/app_button.dart';
import '../../utils/app_text.dart';
import '../../utils/app_textfield.dart';
import '../../utils/colors.dart';
import '../../utils/pickImages.dart';
import '../../utils/show_shanckbar.dart';

class UpdateProduct extends StatefulWidget {
  final String id;
  final String name;
  final String description;
  final double price;
  final int quantity;
  final String category;
  final List images;

  const UpdateProduct({
    super.key,
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.quantity,
    required this.category,
    required this.images,
  });

  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  UpdateData updateData = UpdateData();

  final _formKey = GlobalKey<FormState>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  late String categoryValue;
  List<String> categories = [
    "Mobile",
    "Laptop",
    "Appliances",
    "Clothing",
    "Cosmetics",
    "Electronics",
  ];

  // String imagePath = "";
  List<String> imagePaths = [];
  List<File> imageFiles = [];
  List<Uint8List> imageBytes = [];
  List<String> base64Strings = [];

  List<File> images = [];

  void selectImage() async {
    var res = await pickImage();
    setState(() {
      images = res!;
    });

    // print(images);
    openImage();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _productNameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _productNameController.text = widget.name;
    _descriptionController.text = widget.description;
    _priceController.text = widget.price.toString();
    _quantityController.text = widget.quantity.toString();
    categoryValue = widget.category;
  }

  openImage() async {
    try {
      for (int i = 0; i < images.length; i++) {
        imagePaths.add(images[i].toString().substring(6));
        // print(i);
      }
      // print(imagePaths);

      for (String path in imagePaths) {
        int pathLength = path.length;
        imageFiles.add(File(path.substring(2, pathLength - 1)));
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

  // Future<void> updateProduct() {
  //   String productName = _productNameController.text;
  //   String description = _descriptionController.text;
  //   double price = double.parse(_priceController.text);
  //   int quantity = int.parse(_quantityController.text);
  //   String category = categoryValue;
  //   List images = base64Strings;
  //   List unchangedImages = widget.images;

  //   if (images.isEmpty) {
  //     return products.doc(widget.id).update({
  //       'productName': productName,
  //       'description': description,
  //       'price': price.toDouble(),
  //       'quantity': quantity.toInt(),
  //       'category': category,
  //       'images': unchangedImages,
  //     }).then((value) {
  //       Navigator.pop(context);
  //       showSnackBar(context, "Product Updated!");
  //     });
  //   } else {
  //     return products.doc(widget.id).update({
  //       'productName': productName,
  //       'description': description,
  //       'price': price.toDouble(),
  //       'quantity': quantity.toInt(),
  //       'category': category,
  //       'images': images,
  //     }).then((value) {
  //       Navigator.pop(context);
  //       showSnackBar(context, "Product Updated!");
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    String categotyValue = widget.category;
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: AppText(
            text: "Update Product",
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
                  value: categotyValue,
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
                        updateData.updateProduct(
                          id: widget.id,
                          reference: products,
                          context: context,
                          productName: _productNameController.text,
                          description: _descriptionController.text,
                          price: double.parse(_priceController.text),
                          quantity: int.parse(_quantityController.text),
                          category: categoryValue,
                          unchangedImages: widget.images,
                          images: base64Strings,
                        );
                        // updateProduct();
                      }
                    },
                    color: AppColors.primaryColor,
                    height: 50,
                    radius: 15,
                    child: const AppText(
                      text: "Update Product",
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
