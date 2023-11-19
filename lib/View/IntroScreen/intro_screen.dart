import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_ecommerce/Model/GetX/Controller/duplicate_controller.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Color/color.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Constant/const.dart';
import 'package:flutter_application_ecommerce/View/RootScreen/root.dart';
import 'package:flutter_application_ecommerce/ViewModel/Intro/intro.dart';
import 'package:get/get.dart';
import 'package:intro_slider/intro_slider.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final duplicateController = Get.find<DuplicateController>();
  late CustomColors colors = duplicateController.colors;
  late List<ContentConfig> contentList = [
    ContentConfig(
        backgroundColor: colors.primary,
        title: "ENPT",
        description:
            "ENPT là ứng dụng mua sắm trực tuyến có trụ sở đặt tại 590 CMT8, Thành phố Hồ Chí Minh",
        pathImage: manImage),
    ContentConfig(
        backgroundColor: colors.primary,
        title: "ENPT",
        description:
            "ENPT thuộc sở hữu của Công ty Group 2. Tích hợp hệ thống quản lý thông tin người dùng, giao nhận và hỗ trợ về khâu thanh toán",
        pathImage: aboutImage),
    ContentConfig(
        backgroundColor: colors.primary,
        title: "ENPT",
        description:
            "Vào năm 2023, ENPT đã được trao giải thưởng Khởi Nghiệp Của Năm trong ấn bản thứ hai của tạp chí Giải thưởng FPT Aptech",
        pathImage: contentImage)
  ];
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(systemNavigationBarColor: colors.primary));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final duplicateController = Get.find<DuplicateController>();
    IntroFunctions splashFunctions = duplicateController.introFunctions;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: IntroSlider(
              renderNextBtn: Container(
                alignment: Alignment.center,
                width: 40,
                height: 30,
                decoration: BoxDecoration(
                    color: colors.whiteColor, borderRadius: BorderRadius.circular(12)),
                child: Icon(
                  CupertinoIcons.right_chevron,
                  color: colors.blackColor,
                ),
              ),
              renderSkipBtn: Container(
                  alignment: Alignment.center,
                  width: 40,
                  height: 30,
                  decoration: BoxDecoration(
                      color: colors.whiteColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: Icon(
                    Icons.skip_next,
                    color: colors.blackColor,
                  )),
              renderDoneBtn: Container(
                  alignment: Alignment.center,
                  width: 40,
                  height: 30,
                  decoration: BoxDecoration(
                      color: colors.whiteColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: Icon(
                    CupertinoIcons.check_mark,
                    color: colors.blackColor,
                  )),
              listContentConfig: contentList,
              onDonePress: () async {
                await splashFunctions.saveLaunchStatus(status: false);
                Navigator.pop(Get.context!);
                Get.to(const RootScreen(
                  index: 0,
                ));
              },
              onSkipPress: () async {
                await splashFunctions.saveLaunchStatus(status: false);
                Navigator.pop(Get.context!);
                Get.to(const RootScreen(
                  index: 0,
                ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
