import 'package:ecommerce/utils/app_text.dart';
import 'package:ecommerce/utils/colors.dart';
import 'package:flutter/material.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: const [
                AppText(
                  text: "Time",
                  color: AppColors.primaryColor,
                  size: 35,
                  weight: FontWeight.bold,
                ),
                AppText(
                  text: "For",
                  color: AppColors.primaryColor,
                  size: 30,
                ),
                AppText(
                  text: "Shopping",
                  color: AppColors.primaryColor,
                  size: 35,
                  weight: FontWeight.w500,
                ),
              ],
            ),
            const Icon(
              Icons.shopping_cart,
              size: 180,
            )
          ],
        ),
      ),
    );
  }
}
