import 'package:abcof_ui/utils/color_extensions.dart';
import 'package:flutter/material.dart';

jsonToColor(dynamic colorData, Color defaultColor,
    {bool isMaterialColor = false}) {
  try {
    if (colorData is Map<String, dynamic> && colorData['color'] != null) {
      int colorCode = int.parse(colorData['color'].replaceAll('#', "0xFF"));
      if ((colorData['isMaterialColor'] == true) || isMaterialColor) {
        return MaterialColor(colorCode, Color(colorCode).toSwatch());
      } else {
        return Color(colorCode);
      }
    } else if (colorData != null) {
      return Color(int.parse(colorData.replaceAll('#', "0xFF")));
    }
    return defaultColor;
  } catch (e) {
    return defaultColor;
  }
}
