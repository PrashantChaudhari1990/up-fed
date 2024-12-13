import 'package:base_mobile_app/utils/color_extensions.dart';
import 'package:base_mobile_app/utils/color_utility.dart';
import 'package:flutter/material.dart';

class ThemeColors {
  static MaterialColor primaryColor = MaterialColor(0xFF0056BC, const Color(0xFF0056BC).toSwatch());
  static dynamic black = Colors.black;
  static dynamic white = Colors.white;
  static dynamic errorColor = Colors.red;
  static dynamic gray1 = const Color(0xFFF7F7F7);
  static dynamic gray3 = const Color(0xFF8E8E8E);
  static dynamic gray4 = const Color(0xFF636363);
  static dynamic linkColor = const Color(0xFF0056BC);

  ThemeColors.fromJson(Map<String, dynamic> json) {
    primaryColor = jsonToColor(json['primaryColor'], primaryColor,isMaterialColor: true);
    black = jsonToColor(json['black'], black);
    white = jsonToColor(json['white'], white);
    errorColor = jsonToColor(json['errorColor'], errorColor);
    gray1 = jsonToColor(json['gray1'], gray1);
    gray3 = jsonToColor(json['gray3'], gray3);
    gray4 = jsonToColor(json['gray4'], gray4);
    linkColor = jsonToColor(json['linkColor'], linkColor);
  }
}