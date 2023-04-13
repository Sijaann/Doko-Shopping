import 'package:ecommerce/utils/colors.dart';
import 'package:flutter/material.dart';

void showSnackBar(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 2),
      showCloseIcon: true,
      closeIconColor: AppColors.secondaryColor,
      elevation: 4,
      content: Text(text),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
