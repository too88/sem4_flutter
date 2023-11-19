import 'dart:convert';
import 'dart:io';

import 'package:badges/badges.dart' as badge;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/Model/GetX/Controller/duplicate_controller.dart';
import 'package:flutter_application_ecommerce/Model/GetX/Controller/profile_controller.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Color/color.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Font/font.dart';
import 'package:flutter_application_ecommerce/Model/Widget/widget.dart';
import 'package:flutter_application_ecommerce/Model/user_model.dart';
import 'package:flutter_application_ecommerce/View/ProfileScreen/AddressScreen/address_screen.dart';
import 'package:flutter_application_ecommerce/View/ProfileScreen/AuthenticationScreen/authentication_screen.dart';
import 'package:flutter_application_ecommerce/View/ProfileScreen/FavoriteScreen/favorite_screen.dart';
import 'package:flutter_application_ecommerce/View/ProfileScreen/OrderScreen/order_screen.dart';
import 'package:flutter_application_ecommerce/ViewModel/Profile/profile.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel? userData;

  const ProfileScreen({
    Key? key,
    this.userData, // nullable and optional
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserModel? userData;

  @override
  void initState() {
    super.initState();
    userRetriever();
  }

  userRetriever() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userInfo = prefs.getString('user') ?? '';
    final tempDecode = jsonDecode(userInfo);
    var convert = UserModel.fromJson(tempDecode);
    setState(() {
      userData = convert;
    });
  }

  userRemove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  @override
  Widget build(BuildContext context) {
    final duplicateController = Get.find<DuplicateController>();
    final profileController = Get.find<ProfileController>();
    final ProfileFunctions profileFunctions =
        profileController.profileFunctions;
    final colors = duplicateController.colors;
    final textStyle = duplicateController.textStyle;
    return DuplicateTemplate(
        colors: colors,
        textStyle: textStyle,
        title: "My Profile",
        child: Padding(
          padding: const EdgeInsets.only(top: 20, right: 15, left: 15),
          child: ListView(
            children: [
              (userData != null) ?
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    color: colors.blackColor, shape: BoxShape.circle),
                child: profileImage(colors: colors),
              ) : Container(),
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 20),
                child: Column(
                  children: [
                    profileName(textStyle: textStyle, userData: userData),
                    const SizedBox(
                      height: 10,
                    ),
                    profileEmail(textStyle: textStyle, userData: userData)
                  ],
                ),
              ),
              profileItem(
                  callback: () {
                    Get.to(const FavoriteScreen());
                  },
                  itemName: "My List",
                  textStyle: textStyle,
                  colors: colors),
              (userData != null)
                  ? profileItem(
                      callback: () {
                        Get.to(const AddressScreen());
                      },
                      itemName: "My Address",
                      textStyle: textStyle,
                      colors: colors)
                  : Container(),
              (userData != null)
                  ? profileItem(
                      callback: () {
                        Get.to(const OrderScreen());
                      },
                      itemName: "Order History",
                      textStyle: textStyle,
                      colors: colors)
                  : Container(),
              profileItem(
                  callback: () async {
                    if (userData != null) {
                      showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            title: Text(
                              "Sign out",
                              style: textStyle.titleLarge
                                  .copyWith(color: colors.red),
                            ),
                            content: Text(
                              "Are you sure you want sign out?",
                              style: textStyle.bodyNormal,
                              overflow: TextOverflow.clip,
                              textAlign: TextAlign.start,
                            ),
                            actions: [
                              CupertinoButton(
                                child: Text("No", style: textStyle.bodyNormal),
                                onPressed: () async {
                                  Get.back();
                                },
                              ),
                              CupertinoButton(
                                child: Text(
                                  "Yes",
                                  style: textStyle.bodyNormal
                                      .copyWith(color: colors.red),
                                ),
                                onPressed: () async {
                                  setState(() {
                                    userData = null;
                                    userRemove('user');
                                  });
                                  Get.back();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      UserModel? result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AuthenticationScreen()),
                      );

                      if (result != null) {
                        setState(() {
                          userData = result;
                        });
                      }
                    }
                  },
                  itemName: signStatus(userData: userData),
                  textStyle: textStyle,
                  colors: colors),
            ],
          ),
        ));
  }
}

Widget profileImage({
  required CustomColors colors,
}) {
  return GetX<ProfileController>(
    builder: (controller) {
      if (controller.userSetImage) {
        final File file = controller.profileFunctions.imageFile()!;
        return ClipRRect(
          borderRadius: BorderRadius.circular(49),
          child: Image.file(
            file,
            fit: BoxFit.cover,
          ),
        );
      } else {
        return Icon(
          CupertinoIcons.person_alt_circle,
          color: colors.whiteColor,
          size: 40,
        );
      }
    },
  );
}

Widget profileName({required CustomTextStyle textStyle, UserModel? userData}) {
  if (userData != null) {
    return Text(
      "Welcome ${userData.fullname}" ?? "",
      style: textStyle.titleLarge,
    );
  } else {
    return Text(
      "Hope you have a nice day \u{1F497}",
      style: textStyle.titleLarge,
    );
  }
}

Widget profileEmail({required CustomTextStyle textStyle, UserModel? userData}) {
  if (userData != null) {
    return Text(
      userData.email ?? "",
      style: textStyle.bodyNormal,
    );
  } else {
    return Text(
      "",
      style: textStyle.bodyNormal,
    );
  }
}

Widget profileItem(
    {required String itemName,
    required CustomTextStyle textStyle,
    required CustomColors colors,
    required GestureTapCallback callback}) {
  return Padding(
    padding: const EdgeInsets.only(top: 15, bottom: 15),
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                itemName,
                style: textStyle.bodyNormal.copyWith(fontSize: 16),
              ),
              CupertinoButton(
                onPressed: callback,
                child: Icon(
                  CupertinoIcons.chevron_right_circle,
                  color: colors.blackColor,
                ),
              )
            ],
          ),
        ),
        Container(
          height: 1.3,
          width: Get.mediaQuery.size.width,
          color: colors.captionColor,
        )
      ],
    ),
  );
}

String signStatus({UserModel? userData}) {
  if (userData != null) {
    return "Sign out";
  } else {
    return "Sign in";
  }
}
