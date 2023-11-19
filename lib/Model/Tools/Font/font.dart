import 'package:flutter/cupertino.dart';
import 'package:flutter_application_ecommerce/Model/Tools/Color/color.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextStyle {
  final CustomColors colors = CustomColors();
  
  late TextStyle bodyNormal =
      GoogleFonts.montserrat().copyWith(fontSize: 16, color: colors.blackColor);

  late TextStyle bodySmall =
      GoogleFonts.montserrat().copyWith(fontSize: 12, color: colors.captionColor);

  late TextStyle titleLarge = GoogleFonts.montserrat().copyWith(
      fontSize: 26, color: colors.blackColor, fontWeight: FontWeight.bold);
}
