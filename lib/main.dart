import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/Model/GetX/Binding/initial_binding.dart';
import 'package:flutter_application_ecommerce/Model/GetX/Controller/duplicate_controller.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Entities/AddressEntity/address_entity.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Entities/OrderEntity/order_entity.dart';
import 'package:flutter_application_ecommerce/Model/Tools/JsonParse/product_parse.dart';
import 'package:flutter_application_ecommerce/View/RootScreen/root.dart';
import 'package:flutter_application_ecommerce/View/IntroScreen/intro_screen.dart';
import 'package:flutter_application_ecommerce/ViewModel/Initial/initial.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HighPriorityInitial.initial();

  //FIXME: Init Hive for Flutter
  await Hive.initFlutter;
  await Hive.openBox<ProductEntity>("CartBox");
  await Hive.openBox<ProductEntity>("Favorite Box");
  await Hive.openBox<AddressEntity>("Address Box");
  await Hive.openBox<OrderEntity>("Order Box");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    bool isFirst =
        Get.find<DuplicateController>().introFunctions.getLaunchStatus();
    return GetMaterialApp(
      initialBinding: InitialBinding(),
      title: 'ENPT App',
      home: isFirst
          ? const IntroScreen()
          : const RootScreen(
              index: 0,
            ),
    );
  }
}
