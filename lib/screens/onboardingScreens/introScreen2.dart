import 'package:ecommerce/utils/app_text.dart';
import 'package:ecommerce/utils/colors.dart';
import 'package:flutter/material.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 15,
          right: 15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                AppText(
                  text: "Shop",
                  color: AppColors.primaryColor,
                  weight: FontWeight.bold,
                  size: 35,
                ),
                AppText(
                  text: "From Comfort of",
                  color: AppColors.primaryColor,
                  size: 30,
                ),
                AppText(
                  text: "Your Home",
                  color: AppColors.primaryColor,
                  size: 25,
                  weight: FontWeight.w500,
                )
              ],
            ),
            const Center(
              child: Image(
                image: AssetImage("assets/Catalogue-amico.png"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
