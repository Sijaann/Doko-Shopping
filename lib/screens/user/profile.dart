import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/logic/updateData.dart';
import 'package:ecommerce/utils/app_button.dart';
import 'package:ecommerce/utils/app_text.dart';
import 'package:ecommerce/utils/app_textfield.dart';
import 'package:ecommerce/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final User user = FirebaseAuth.instance.currentUser!;
  final CollectionReference reference =
      FirebaseFirestore.instance.collection('users');

  final UpdateData updateData = UpdateData();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  // String name = "";
  // String address = "";
  // String contact = "";
  // String email = "";
  void getUserData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get()
        .then((value) {
      setState(() {
        nameController.text = value.data()!['name'];
        emailController.text = value.data()!['email'];
        contactController.text = value.data()!['contact'];
        addressController.text = value.data()!['address'];
      });
    });
  }

  // void updateUserData() {
  //   updateData.updateUserInfo(
  //     id: user.uid,
  //     context: context,
  //     reference: reference,
  //     name: nameController.text,
  //     contact: contactController.text,
  //     email: emailController.text,
  //     address: addressController.text,
  //   );
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: AppText(
            text: "Profile",
            color: AppColors.secondaryColor,
          ),
        ),
      ),
      // body: Padding(
      //   padding: const EdgeInsets.symmetric(vertical: 20),
      //   child: Container(
      //     color: AppColors.secondaryColor,
      //     width: MediaQuery.of(context).size.width,
      //     height: MediaQuery.of(context).size.height * 0.23,
      //     child: Column(
      //       children: [
      //         Padding(
      //           padding: const EdgeInsets.symmetric(
      //             horizontal: 20,
      //             vertical: 15,
      //           ),
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [
      //               const AppText(
      //                 text: "Full Name",
      //                 color: AppColors.primaryColor,
      //                 size: 16,
      //               ),
      //               Row(
      //                 children: [
      //                   Padding(
      //                     padding: const EdgeInsets.only(right: 15),
      //                     child: AppText(
      //                       text: name,
      //                       color: AppColors.hintTextColor,
      //                       weight: FontWeight.w500,
      //                       size: 16,
      //                     ),
      //                   ),
      //                   GestureDetector(
      //                     onTap: () {},
      //                     child: const Icon(
      //                       Icons.arrow_forward_ios,
      //                       color: AppColors.hintTextColor,
      //                       size: 15,
      //                     ),
      //                   )
      //                 ],
      //               ),
      //             ],
      //           ),
      //         ),
      //         const Padding(
      //           padding: EdgeInsets.symmetric(horizontal: 15),
      //           child: Divider(
      //             thickness: 1,
      //             color: AppColors.hintTextColor,
      //           ),
      //         ),
      //         Padding(
      //           padding: const EdgeInsets.symmetric(
      //             horizontal: 20,
      //             vertical: 15,
      //           ),
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [
      //               const AppText(
      //                 text: "Contact",
      //                 color: AppColors.primaryColor,
      //                 size: 16,
      //               ),
      //               Row(
      //                 children: [
      //                   Padding(
      //                     padding: const EdgeInsets.only(right: 15),
      //                     child: AppText(
      //                       text: contact,
      //                       color: AppColors.hintTextColor,
      //                       weight: FontWeight.w500,
      //                       size: 16,
      //                     ),
      //                   ),
      //                   GestureDetector(
      //                     onTap: () {},
      //                     child: const Icon(
      //                       Icons.arrow_forward_ios,
      //                       color: AppColors.hintTextColor,
      //                       size: 15,
      //                     ),
      //                   )
      //                 ],
      //               ),
      //             ],
      //           ),
      //         ),
      //         const Padding(
      //           padding: EdgeInsets.symmetric(horizontal: 15),
      //           child: Divider(
      //             thickness: 1,
      //             color: AppColors.hintTextColor,
      //           ),
      //         ),
      //         Padding(
      //           padding: const EdgeInsets.symmetric(
      //             horizontal: 20,
      //             vertical: 15,
      //           ),
      //           child: Row(
      //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //             children: [
      //               const AppText(
      //                 text: "Email",
      //                 color: AppColors.primaryColor,
      //                 size: 16,
      //               ),
      //               Row(
      //                 children: [
      //                   Padding(
      //                     padding: const EdgeInsets.only(right: 15),
      //                     child: AppText(
      //                       text: email,
      //                       color: AppColors.hintTextColor,
      //                       weight: FontWeight.w500,
      //                       size: 16,
      //                     ),
      //                   ),
      //                   GestureDetector(
      //                     onTap: () {},
      //                     child: const Icon(
      //                       Icons.arrow_forward_ios,
      //                       color: AppColors.hintTextColor,
      //                       size: 15,
      //                     ),
      //                   )
      //                 ],
      //               ),
      //             ],
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.person),
                      SizedBox(
                        height: 55,
                        width: MediaQuery.of(context).size.width * 0.81,
                        child: AppTextField(
                          controller: nameController,
                          hide: false,
                          radius: 10,
                          hintText: "Name",
                          labelText: "Name",
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.phone),
                      SizedBox(
                        height: 55,
                        width: MediaQuery.of(context).size.width * 0.81,
                        child: AppTextField(
                          controller: contactController,
                          hide: false,
                          radius: 10,
                          hintText: "Contact",
                          labelText: "Contact",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.email),
                      SizedBox(
                        height: 55,
                        width: MediaQuery.of(context).size.width * 0.81,
                        child: AppTextField(
                          controller: emailController,
                          hide: false,
                          radius: 10,
                          hintText: "Email",
                          labelText: "Email",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.location_on),
                      SizedBox(
                        height: 55,
                        width: MediaQuery.of(context).size.width * 0.81,
                        child: AppTextField(
                          controller: addressController,
                          hide: false,
                          radius: 10,
                          hintText: "Ex: Nadipur, Pokhara",
                          labelText: "Address",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: AppButton(
                  onTap: () {
                    // setState(() {
                    //   updateUserData();
                    // });
                    updateData.updateUserInfo(
                      id: user.uid,
                      context: context,
                      reference: reference,
                      name: nameController.text,
                      contact: contactController.text,
                      email: emailController.text,
                      address: addressController.text,
                    );
                  },
                  color: AppColors.primaryColor,
                  height: 50,
                  radius: 10,
                  child: const AppText(
                    text: "Update",
                    color: AppColors.secondaryColor,
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
