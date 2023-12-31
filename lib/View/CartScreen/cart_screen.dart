import 'dart:convert';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/Model/GetX/Controller/duplicate_controller.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Constant/const.dart';
import 'package:flutter_application_ecommerce/Model/Widget/widget.dart';
import 'package:flutter_application_ecommerce/Model/user_model.dart';
import 'package:flutter_application_ecommerce/View/CartScreen/CheckoutScreen/check_screen.dart';
import 'package:flutter_application_ecommerce/View/CartScreen/bloc/cart_bloc.dart';
import 'package:flutter_application_ecommerce/ViewModel/controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tap_debouncer/tap_debouncer.dart';
import 'package:http/http.dart';

CartBloc? cartBloc;
const int kCooldownLongMs = 3000;
const int kCooldownShortMs = 1200;

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  UserModel? userData;
  OrderController orderController = OrderController();

  @override
  void initState() {
    super.initState();
    userRetriever();
  }

  @override
  void dispose() {
    cartBloc?.close();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = CartBloc();
        bloc.add(CartStart());
        cartBloc = bloc;
        return bloc;
      },
      child: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          final duplicateController = Get.find<DuplicateController>();
          final colors = duplicateController.colors;
          final textStyle = duplicateController.textStyle;
          final uiDuplicate = duplicateController.uiDuplicate;
          if (state is CartSuccess) {
            final productList = state.productList;
            final String totalPrice = state.totalPrice;
            final formatPrice = NumberFormat.currency(
                locale: 'eu',
                customPattern: '#,### \u00a4',
                symbol: 'VND',
                decimalDigits: 0);

            return DuplicateTemplate(
                colors: colors,
                textStyle: textStyle,
                title: "My Cart",
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: 120),
                        physics: uiDuplicate.defaultScroll,
                        itemCount: productList.length,
                        itemBuilder: (context, index) {
                          final product = productList[index];
                          return HorizontalProductView(
                              colors: colors,
                              margin: const EdgeInsets.only(
                                  top: 15, right: 10, bottom: 15, left: 10),
                              product: product,
                              widget: CupertinoButton(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                                onPressed: () {},
                                child: TapDebouncer(
                                  cooldown: const Duration(
                                      milliseconds: kCooldownShortMs),
                                  onTap: () async {
                                    final bool isDeleted =
                                        await duplicateController.cartFunctions
                                            .deleteProduct(index: index);
                                    if (isDeleted) {
                                      Get.snackbar("Delete", "",
                                          messageText: Text(
                                            "Product removed successfully",
                                            style: textStyle.bodyNormal,
                                          ),
                                          backgroundColor: colors.gray);
                                      cartBloc!.add(CartStart());
                                    }
                                  },
                                  builder: (_, TapDebouncerFunc? onTap) =>
                                      ElevatedButton(
                                    style: ButtonStyle(
                                        foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.transparent),
                                        shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18.0),
                                                side: const BorderSide(
                                                    color:
                                                        Colors.transparent)))),
                                    onPressed: onTap,
                                    child: onTap == null
                                        ? Icon(
                                            Icons.delete,
                                            color: colors.blackColor,
                                          )
                                        : Icon(
                                            Icons.delete,
                                            color: colors.blackColor,
                                          ),
                                  ),
                                ),
                              ),
                              textStyle: textStyle);
                        },
                      ),
                    ),
                    CartBottomItem(
                      colors: colors,
                      navigateName: "Checkout",
                      widget: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Total price",
                            style: textStyle.bodySmall
                                .copyWith(color: colors.captionColor),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            width: 200,
                            child: AutoSizeText(
                              formatPrice.format(double.parse(totalPrice)),
                              style:
                                  textStyle.titleLarge.copyWith(fontSize: 20),
                              maxFontSize: 25,
                              minFontSize: 16,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                      textStyle: textStyle,
                      callback: () async {
                        if (userData != null) {
                          //TODO: call create Order right here!
                          final response = await post(
                            Uri.parse("http://172.17.32.1:8080/api/v1/order"),
                            headers: <String, String>{
                              'Content-type': 'application/json',
                              "Accept": "application/json",
                              'Authorization': 'Bearer ${userData!.token!}'
                            },
                            body: json.encode({
                              "products": [
                                for (final ele in productList)
                                  {
                                    "id": ele.id,
                                    "name": ele.name,
                                    "price": ele.price,
                                    "quantity": 1,
                                    "thumbnail": ele.imageUrl
                                  }
                              ]
                            }),
                          );

                          Get.to(CheckoutScreen(
                              res: response,
                              productList: productList,
                              totalPrice: totalPrice));
                        } else {
                          loginRequiredDialog(textStyle: textStyle);
                        }
                      },
                    ),
                  ],
                ));
          } else if (state is CartLoading) {
            return const CustomLoading();
          } else if (state is CartError) {
            return AppException(
              callback: () {
                cartBloc!.add(CartStart());
              },
            );
          } else if (state is CartEmpty) {
            return EmptyScreen(
              colors: colors,
              textStyle: textStyle,
              lottieName: emptyCartLottie,
              content:
                  "Your cart is empty! Look like you have not added any product to your cart yet",
              title: "My cart",
            );
          }
          return Container();
        },
      ),
    );
  }
}
