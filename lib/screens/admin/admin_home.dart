import 'package:ecommerce/utils/app_text.dart';
import 'package:ecommerce/utils/colors.dart';
import 'package:flutter/material.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: AppText(
              text: "Admin",
              color: AppColors.secondaryColor,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.logout_rounded),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: AppText(
                  text: "All Verified Vendors",
                  color: AppColors.primaryColor,
                  weight: FontWeight.w500,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 15,
                  itemBuilder: (context, index) {
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        title: AppText(
                          text: "Demo Vendor",
                          color: AppColors.primaryColor,
                        ),
                        subtitle: AppText(
                          text: "Contact Info",
                          color: AppColors.hintTextColor,
                          size: 15,
                        ),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                        ),
                        onTap: () {},
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ));
  }
}
