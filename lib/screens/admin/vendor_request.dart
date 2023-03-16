import 'package:ecommerce/utils/app_text.dart';
import 'package:ecommerce/utils/colors.dart';
import 'package:flutter/material.dart';

class VendorRequest extends StatefulWidget {
  const VendorRequest({super.key});

  @override
  State<VendorRequest> createState() => _VendorRequestState();
}

class _VendorRequestState extends State<VendorRequest> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: AppText(
            text: "Pending Requests",
            color: AppColors.secondaryColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10).copyWith(top: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 10),
              child: AppText(
                text: "Requests",
                color: AppColors.primaryColor,
                weight: FontWeight.w500,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    child: ListTile(
                      title: const AppText(
                        text: "Vendor Name",
                        color: AppColors.primaryColor,
                      ),
                      subtitle: const AppText(
                        text: "Contact Details",
                        color: AppColors.hintTextColor,
                        size: 15,
                      ),
                      trailing: SizedBox(
                        width: 65,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: const Icon(
                                Icons.check,
                                color: Colors.green,
                                size: 18,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {},
                              child: const Icon(
                                Icons.delete,
                                color: Colors.red,
                                size: 18,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
