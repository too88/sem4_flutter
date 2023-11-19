import 'package:flutter/material.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Entities/AddressEntity/address_entity.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Font/font.dart';
import 'package:hive_flutter/adapters.dart';

class AddressFunctions {
  final String addressBox = "Address Box";
  final ValueNotifier<bool> valueNotifier = ValueNotifier(false);
  final List<String> countriesList = [
    "Thành phố Hà Nội",
    "Thành phố Hồ Chí Minh",
    "Thành phố Hải Phòng",
    "Thành phố Đà Nẵng",
    "Thành phố Cần Thơ",
    "Tỉnh Hà Giang",
    "Tỉnh Cao Bằng",
    "Tỉnh Bắc Kạn",
    "Tỉnh Tuyên Quang",
    "Tỉnh Lào Cai",
    "Tỉnh Điện Biên",
    "Tỉnh Lai Châu",
    "Tỉnh Sơn La",
    "Tỉnh Yên Bái",
    "Tỉnh Hoà Bình",
    "Tỉnh Thái Nguyên",
    "Tỉnh Lạng Sơn",
    "Tỉnh Quảng Ninh",
    "Tỉnh Bắc Giang",
    "Tỉnh Phú Thọ",
    "Tỉnh Vĩnh Phúc",
    "Tỉnh Bắc Ninh",
    "Tỉnh Hải Dương",
    "Tỉnh Hưng Yên",
    "Tỉnh Thái Bình",
    "Tỉnh Hà Nam",
    "Tỉnh Nam Định",
    "Tỉnh Ninh Bình",
    "Tỉnh Thanh Hóa",
    "Tỉnh Nghệ An",
    "Tỉnh Hà Tĩnh",
    "Tỉnh Quảng Bình",
    "Tỉnh Quảng Trị",
    "Tỉnh Thừa Thiên",
    "Tỉnh Quảng Nam",
    "Tỉnh Quảng Ngãi",
    "Tỉnh Bình Định",
    "Tỉnh Phú Yên",
    "Tỉnh Khánh Hòa",
    "Tỉnh Ninh Thuận",
    "Tỉnh Bình Thuận",
    "Tỉnh Kon Tum",
    "Tỉnh Gia Lai",
    "Tỉnh Đắk Lắk",
    "Tỉnh Đắk Nông",
    "Tỉnh Lâm Đồng",
    "Tỉnh Bình Phước",
    "Tỉnh Tây Ninh",
    "Tỉnh Bình Dương",
    "Tỉnh Đồng Nai",
    "Tỉnh Bà Rịa",
    "Tỉnh Long An",
    "Tỉnh Tiền Giang",
    "Tỉnh Bến Tre",
    "Tỉnh Trà Vinh",
    "Tỉnh Vĩnh Long",
    "Tỉnh Đồng Tháp",
    "Tỉnh An Giang",
    "Tỉnh Kiên Giang",
    "Tỉnh Hậu Giang",
    "Tỉnh Sóc Trăng",
    "Tỉnh Bạc Liêu",
    "Tỉnh Cà Mau",
  ];

  Future<void> openAddressBox() async {
    bool isBoxOpen = Hive.isBoxOpen(addressBox);
    if (!isBoxOpen) {
      await Hive.openBox<AddressEntity>(addressBox);
    }
  }

  Future<void> addToAddressBox({required AddressEntity addressEntity}) async {
    await openAddressBox();
    final box = Hive.box<AddressEntity>(addressBox);
    await box.put(addressEntity.postalCode, addressEntity);
    valueNotifier.value = !valueNotifier.value;
    await box.close();
  }

  Future<List<AddressEntity>> getAddressList() async {
    await openAddressBox();
    final box = Hive.box<AddressEntity>(addressBox);
    final List<AddressEntity> addressList = [];
    for (var element in (box.values.toList())) {
      addressList.add(element);
    }
    await box.close();
    return addressList;
  }

  Future<bool> removeAddress({required int postalCode}) async {
    await openAddressBox();
    final box = Hive.box<AddressEntity>(addressBox);
    await box.delete(postalCode);
    valueNotifier.value = !valueNotifier.value;
    await box.close();

    return true;
  }

  Future<List<DropdownMenuItem>> countryMenuList({
    required CustomTextStyle textStyle,
  }) async {
    List<DropdownMenuItem> popupMenuList = [];
    for (var element in countriesList) {
      popupMenuList.add(
        DropdownMenuItem(
          value: element,
          child: Text(
            element,
            style: textStyle.bodyNormal,
          ),
        ),
      );
    }
    return popupMenuList;
  }

  Future<List<DropdownMenuItem>> addressItemList(
      {required CustomTextStyle textStyle}) async {
    final List<AddressEntity> addressList = await getAddressList();
    final List<DropdownMenuItem> popupMenuList = [];
    for (var element in addressList) {
      popupMenuList.add(
        DropdownMenuItem(
         
          value: element.addressDetail,
          child: Text(
            element.addressName,
            style: textStyle.bodyNormal,
          ),
        ),
          
          );
    }
    return popupMenuList;
  }

  Future<bool> editAddress(
      {required AddressEntity addressEntity, required int postalCode}) async {
    await openAddressBox();
    final box = Hive.box<AddressEntity>(addressBox);
    await box.delete(postalCode);
    await box.put(addressEntity.postalCode, addressEntity);
    valueNotifier.value = !valueNotifier.value;
    await box.close();
    return true;
  }
}
