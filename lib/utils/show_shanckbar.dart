import 'package:ecommerce/utils/colors.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      showCloseIcon: true,
      closeIconColor: AppColors.secondaryColor,
      elevation: 4,
      content: Text(text),
    ),
  );
}
