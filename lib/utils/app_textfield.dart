// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ecommerce/utils/colors.dart';

class AppTextField extends StatelessWidget {
  final String? labelText;
  final bool hide;
  final Icon? leadingIcon;
  final IconButton? iconButton;
  final double radius;
  final TextEditingController? controller;
  final TextInputType? type;
  final String hintText;
  final int? maxLines;
  const AppTextField({
    Key? key,
    this.labelText,
    required this.hide,
    this.leadingIcon,
    this.iconButton,
    required this.radius,
    this.controller,
    this.type = TextInputType.text,
    this.maxLines = 1,
    required this.hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Please enter $hintText";
        }
      },
      controller: controller,
      maxLines: maxLines,
      keyboardType: type,
      obscureText: hide,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        hintStyle: GoogleFonts.montserrat(
          fontSize: 15,
          color: AppColors.hintTextColor,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radius),
          borderSide: const BorderSide(
            width: 2,
          ),
        ),
        prefixIcon: leadingIcon,
        suffixIcon: iconButton,
      ),
    );
  }
}
