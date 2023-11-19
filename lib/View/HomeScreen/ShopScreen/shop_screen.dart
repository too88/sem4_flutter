import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/Model/GetX/Controller/duplicate_controller.dart';
import 'package:flutter_application_ecommerce/Model/Tools/JsonParse/product_parse.dart';
import 'package:flutter_application_ecommerce/Model/Widget/widget.dart';
import 'package:get/get.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({
    super.key,
    required this.title,
    required this.productList,
  });
  final String title;
  final List<ProductEntity> productList;

  @override
  Widget build(BuildContext context) {
    final DuplicateController duplicateController =
        Get.find<DuplicateController>();
    final colors = duplicateController.colors;
    final textStyle = duplicateController.textStyle;
    final uiDuplicate = duplicateController.uiDuplicate;
    return Scaffold(
      appBar: AppBar(
        foregroundColor: colors.blackColor,
        backgroundColor: colors.whiteColor,
        centerTitle: true,
        title: Text(
          title,
          style: textStyle.titleLarge.copyWith(color: colors.blackColor),
        ),
      ),
      backgroundColor: colors.whiteColor,
      body: gridViewScreensContainer(
        colors: colors,
        child: ProductGrideView(
            productList: productList,
            uiDuplicate: uiDuplicate,
            colors: colors,
            textStyle: textStyle),
      ),
    );
  }
}
