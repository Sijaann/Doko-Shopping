import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/main.dart';
import 'package:ecommerce/screens/onboardingScreens/introScreen2.dart';
import 'package:ecommerce/screens/onboardingScreens/introScreen3.dart';
import 'package:ecommerce/screens/onboardingScreens/introScren1.dart';
import 'package:ecommerce/utils/app_text.dart';
import 'package:ecommerce/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  PageController controller = PageController();

  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        PageView(
          controller: controller,
          onPageChanged: (index) {
            setState(() {
              onLastPage = (index == 2);
            });
          },
          children: const [
            IntroPage1(),
            IntroPage2(),
            IntroPage3(),
          ],
        ),
        Container(
          alignment: const Alignment(0, 0.8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //Skip
              TextButton(
                onPressed: () {
                  controller.jumpToPage(2);
                },
                child: const AppText(
                  text: "Skip",
                  color: AppColors.primaryColor,
                  weight: FontWeight.w500,
                ),
              ),

              SmoothPageIndicator(
                controller: controller,
                count: 3,
              ),

              //Next / Done
              onLastPage == true
                  ? TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RedirectPage(),
                          ),
                        );
                      },
                      child: const AppText(
                        weight: FontWeight.w500,
                        text: "Done",
                        color: AppColors.primaryColor,
                      ),
                    )
                  : TextButton(
                      onPressed: () {
                        controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      },
                      child: const AppText(
                        weight: FontWeight.w500,
                        text: "Next",
                        color: AppColors.primaryColor,
                      ),
                    ),
            ],
          ),
        ),
      ],
    ));
  }
}
