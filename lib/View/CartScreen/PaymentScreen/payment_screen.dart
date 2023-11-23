import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/Model/GetX/Controller/duplicate_controller.dart';
import 'package:flutter_application_ecommerce/Model/GetX/Controller/profile_controller.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Color/color.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Entities/OrderEntity/order_entity.dart';
import 'package:flutter_application_ecommerce/Model/Tools/JsonParse/product_parse.dart';
import 'package:flutter_application_ecommerce/Model/Widget/widget.dart';
import 'package:flutter_application_ecommerce/View/CartScreen/cart_screen.dart';
import 'package:flutter_application_ecommerce/View/RootScreen/root.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({
    super.key,
    required this.totalPrice,
    required this.productList,
    required this.addressDetail,
    required this.addressName,
    required this.token,
    required this.order,

  });

  final String totalPrice;
  final List<ProductEntity> productList;
  final String addressDetail;
  final String addressName;
  final String token;
  final http.Response order;

  @override
  Widget build(BuildContext context) {
    final duplicateController = Get.find<DuplicateController>();
    final profileController = Get.find<ProfileController>();
    final colors = duplicateController.colors;
    final textStyle = duplicateController.textStyle;
    final paymentFunctions = duplicateController.paymentFunctions;
    final DateTime dateTime = DateTime.now();
    final formatPrice = NumberFormat.currency(
        locale: 'eu',
        customPattern: '#,### \u00a4',
        symbol: 'VND',
        decimalDigits: 0);

    log("+++++++++++LOG HERE+++++++++ ${json.decode(order.body)["id"]}");
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        height: 60,
        width: Get.mediaQuery.size.width * 0.7,
        child: FloatingActionButton.extended(
            backgroundColor: colors.primary,
            onPressed: () {
              showCupertinoDialog(
                context: context,
                builder: (context) {
                  return CupertinoAlertDialog(
                    title: Text(
                      "Pay",
                      style: textStyle.bodyNormal,
                    ),
                    content: Text(
                      "Do you want pay?",
                      style: textStyle.bodyNormal,
                    ),
                    actions: [
                      CupertinoButton(
                        child: const Text("No"),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                      CupertinoButton(
                        child: const Text("Yes"),
                        onPressed: () async {
                          //TODO: call update Order right here!
                          final response = await http.put(
                            Uri.parse("http://172.17.32.1:8080/api/v1/order/${json.decode(order.body)["id"]}"),
                            headers: <String, String>{
                              'Content-type': 'application/json',
                              "Accept": "application/json",
                              'Authorization': 'Bearer $token'
                            },
                            body: json.encode({
                              "status": "PAID",
                              "products": [
                                for(final ele in productList) {
                                  "id": ele.id,
                                  "name": ele.name,
                                  "price": ele.price,
                                  "quantity": 1,
                                  "thumbnail": ele.imageUrl
                                }
                              ]
                            }),
                          );

                          await profileController.orderFunctions.addToOrderBox(
                              orderEntity: OrderEntity(
                                  time: dateTime,
                                  totalPrice: totalPrice,
                                  productList: productList));
                          bool isCommpleated = await duplicateController
                              .cartFunctions
                              .clearCartBox();

                          if (isCommpleated) {
                            Get.offAll(const RootScreen(
                              index: 1,
                            ));

                            snackBar(
                                title: "Pay",
                                message: "Successfully payed",
                                textStyle: textStyle,
                                colors: colors);
                          }
                        },
                      ),
                    ],
                  );
                },
              );
            },
            label: Text(
              "Pay",
              style: textStyle.titleLarge.copyWith(color: colors.whiteColor),
            )),
      ),
      appBar: AppBar(
        backgroundColor: colors.whiteColor,
        foregroundColor: colors.blackColor,
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: Text(
          "E-Payment",
          style: textStyle.titleLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: SingleChildScrollView(
          physics: duplicateController.uiDuplicate.defaultScroll,
          child: Column(
            children: [
              // Align(
              //   alignment: Alignment.center,
              //   child: SvgPicture.string(
              //     paymentFunctions.createBarcode(),
              //   ),
              // ),
              duplicateContainer(
                colors: colors,
                widget: Column(
                  children: [
                    SizedBox(
                      height: 100,
                      width: Get.mediaQuery.size.width * 0.8,
                      child: GridView.builder(
                        physics: duplicateController.uiDuplicate.defaultScroll,
                        itemCount: productList.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10),
                        itemBuilder: (context, index) {
                          return SizedBox(
                            height: 40,
                            child: CircleAvatar(
                              backgroundColor: colors.whiteColor,
                              foregroundImage: CachedNetworkImageProvider(
                                  "http://172.17.32.1:8080/api/v1/image/${productList[index].imageUrl}"),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                            width: Get.mediaQuery.size.width * 0.48,
                            child: Row(
                              children: [
                                Text(
                                  productList[0].name.substring(0, 10),
                                  style: textStyle.bodyNormal
                                      .copyWith(fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.clip,
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(
                                  width: 7,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(const CartScreen());
                                  },
                                  child: Text(
                                    "and more",
                                    style: textStyle.bodySmall,
                                  ),
                                ),
                                // Text(
                                //   "and more",
                                //   style: textStyle.bodySmall,
                                // ),
                              ],
                            )),
                        Column(
                          children: [
                            Icon(
                              CupertinoIcons.number_circle,
                              color: colors.blackColor,
                              size: 20,
                            ),
                            Text(
                              "Count : ${productList.length}",
                              style: textStyle.bodySmall
                                  .copyWith(color: colors.blackColor),
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              duplicateContainer(
                  colors: colors,
                  widget: Column(
                    children: [
                      duplicateRowItem(
                        colors: colors,
                        prefix: Text(
                          "Name",
                          style: textStyle.bodyNormal,
                        ),
                        suffix: SizedBox(
                          width: 200,
                          child: Expanded(
                              child: Text(
                            textAlign: TextAlign.end,
                            addressName,
                            style: textStyle.bodyNormal
                                .copyWith(fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                      duplicateRowItem(
                        colors: colors,
                        prefix: Text(
                          "Address",
                          style: textStyle.bodyNormal,
                        ),
                        suffix: SizedBox(
                          width: 200,
                          child: Expanded(
                              child: Text(
                            textAlign: TextAlign.end,
                            addressDetail,
                            style: textStyle.bodyNormal
                                .copyWith(fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                      duplicateRowItem(
                          colors: colors,
                          prefix: Text(
                            "Payment Methods",
                            style: textStyle.bodyNormal,
                          ),
                          suffix: Text(
                            "Cash",
                            style: textStyle.bodyNormal
                                .copyWith(fontWeight: FontWeight.bold),
                          )),
                      duplicateRowItem(
                          colors: colors,
                          prefix: Text(
                            "Date",
                            style: textStyle.bodyNormal,
                          ),
                          suffix: Text(
                            dateTime.toString().substring(0, 16),
                            style: textStyle.bodyNormal
                                .copyWith(fontWeight: FontWeight.bold),
                          )),
                      duplicateRowItem(
                          colors: colors,
                          prefix: Text(
                            "Total",
                            style: textStyle.bodyNormal,
                          ),
                          suffix: Text(
                            formatPrice.format(double.parse(totalPrice)),
                            style: textStyle.bodyNormal
                                .copyWith(fontWeight: FontWeight.bold),
                          )),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget duplicateContainer(
      {required Widget widget, required CustomColors colors}) {
    return Container(
        width: Get.mediaQuery.size.width,
        margin: const EdgeInsets.only(top: 25, bottom: 25),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: colors.gray,
          borderRadius: BorderRadius.circular(15),
        ),
        child: widget);
  }

  Widget duplicateRowItem(
      {required Widget prefix,
      required Widget suffix,
      required CustomColors colors}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [prefix, suffix],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Divider(
          thickness: 0.5,
          height: 1,
          color: colors.captionColor,
        )
      ],
    );
  }
}
