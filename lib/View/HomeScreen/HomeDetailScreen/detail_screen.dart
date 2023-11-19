import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/Model/GetX/Controller/duplicate_controller.dart';
import 'package:flutter_application_ecommerce/Model/GetX/Controller/profile_controller.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Color/color.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Font/font.dart';
import 'package:flutter_application_ecommerce/Model/Tools/JsonParse/product_parse.dart';
import 'package:flutter_application_ecommerce/Model/Widget/widget.dart';
import 'package:flutter_application_ecommerce/View/CartScreen/cart_screen.dart';
import 'package:flutter_application_ecommerce/ViewModel/Cart/cart.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

const int kCooldownLongMs = 3000;
const int kCooldownShortMs = 1200;
final duplicateController = Get.find<DuplicateController>();

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.productEntity});

  final ProductEntity productEntity;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final double rate = Random.secure().nextInt(5).toDouble();
  final double randomReview = Random.secure().nextInt(10000).toDouble();
  final CartFunctions cartFunctions = duplicateController.cartFunctions;
  int? _counter;

  @override
  void initState() {
    super.initState();
    _loadData().then((value) {
      setState(() {
        _counter = value.length;
      });
    });
  }

  Future<List<ProductEntity>> _loadData() async {
    final data = await cartFunctions.getProductFromHive();
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();
    final CustomTextStyle textStyle = duplicateController.textStyle;
    final CustomColors colors = duplicateController.colors;
    final profileFunctions = profileController.profileFunctions;
    final bool isInFavorite =
        profileFunctions.isInFavoriteBox(productEntity: widget.productEntity);
    final formatPrice = NumberFormat.currency(
        locale: 'eu',
        customPattern: '#,### \u00a4',
        symbol: 'VND',
        decimalDigits: 0);

    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: paddingFromRL(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: colors.gray,
                child: IconButton(
                  highlightColor: colors.whiteColor,
                  splashColor: colors.whiteColor,
                  icon: isInFavorite
                      ? Icon(
                          CupertinoIcons.star_fill,
                          color: colors.primary,
                        )
                      : Icon(
                          CupertinoIcons.star,
                          color: colors.primary,
                        ),
                  onPressed: () async {
                    if (isInFavorite) {
                      await profileFunctions.removeFavorite(
                          productEntity: widget.productEntity);
                      setState(() {});
                    } else {
                      await profileFunctions.addToFavorite(
                          productEntity: widget.productEntity);
                      setState(() {});
                    }
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: CupertinoTheme(
                    data: CupertinoThemeData(primaryColor: colors.primary),
                    child: TapDebouncer(
                      cooldown: const Duration(milliseconds: kCooldownShortMs),
                      onTap: () async {
                        List isAdd = await cartFunctions.addToCart(
                            productEntity: widget.productEntity);
                        if (isAdd != null) {
                          setState(() {
                            _counter = isAdd.length;
                          });
                          Get.snackbar("Add to cart", "",
                              messageText: Text(
                                "Successfully add to cart",
                                style: textStyle.bodyNormal,
                              ),
                              backgroundColor: colors.gray);
                        }
                      },
                      builder: (_, TapDebouncerFunc? onTap) => ElevatedButton(
                        style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xffCC9D76)),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: const BorderSide(
                                        color: Color(0xffCC9D76))))),
                        onPressed: onTap,
                        // alternative with manual test onTap for null in builder
                        child: onTap == null
                            ? const Text('Wait...')
                            : const Text('Add to cart'),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: colors.whiteColor,
        appBar: AppBar(
          foregroundColor: colors.blackColor,
          backgroundColor: colors.whiteColor,
          centerTitle: true,
          title: Text(
            "Product Detail",
            style: textStyle.titleLarge,
          ),
          actions: [
            CartLengthBadge(
              count: _counter.toString(),
              duplicateController: duplicateController,
              colors: colors,
              textStyle: textStyle,
              badgeCallback: () {
                Get.to(const CartScreen());
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              width: Get.size.width,
              height: Get.size.height * 0.4,
              color: colors.whiteColor,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      top: 15,
                    ),
                    height: 300,
                    width: 300,
                    child: CachedNetworkImage(
                      imageUrl:
                          "http://172.17.32.1:8080/api/v1/image/${widget.productEntity.imageUrl}",
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: colors.whiteColor,
              ),
              child: Container(
                height: Get.size.height * 0.4,
                margin: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                    color: colors.whiteColor,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(15))),
                child: SingleChildScrollView(
                  physics: duplicateController.uiDuplicate.defaultScroll,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          paddingFromRL(
                            child: Text(
                              widget.productEntity.name,
                              style: textStyle.titleLarge,
                              overflow: TextOverflow.clip,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              RatingBar.builder(
                                initialRating: rate,
                                direction: Axis.horizontal,
                                maxRating: 5,
                                allowHalfRating: true,
                                itemBuilder: (context, index) {
                                  return Icon(
                                    Icons.star,
                                    color: colors.primary,
                                  );
                                },
                                onRatingUpdate: (value) {
                                  Get.dialog(CupertinoAlertDialog(
                                    title: Center(
                                      child: RatingBarIndicator(
                                        itemCount: 5,
                                        rating: value,
                                        itemBuilder: (context, index) {
                                          return Icon(
                                            Icons.star,
                                            color: colors.primary,
                                          );
                                        },
                                      ),
                                    ),
                                    content: Text(
                                      "Thank you for rating",
                                      style: textStyle.titleLarge,
                                    ),
                                  ));
                                },
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                "${randomReview.toStringAsFixed(0)} Votes",
                                style: textStyle.bodyNormal,
                              )
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      paddingFromRL(
                          child: Text(
                        widget.productEntity.description.substring(5, widget.productEntity.description.length - 6),
                        style: textStyle.bodySmall
                            .copyWith(color: colors.captionColor),
                      )),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        formatPrice.format(widget.productEntity.price),
                        style: textStyle.titleLarge
                            .copyWith(color: colors.primary),
                      ),
                      Text(
                        widget.productEntity.productType,
                        style: textStyle.titleLarge
                            .copyWith(color: colors.primary),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}

Widget paddingFromRL({required Widget child}) {
  return Padding(
    padding: const EdgeInsets.only(left: 15, right: 15),
    child: child,
  );
}
