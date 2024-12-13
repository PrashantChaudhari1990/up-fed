import 'package:base_mobile_app/themes/styles/fonts.dart';
import 'package:base_mobile_app/themes/styles/typography.dart';
import 'package:base_mobile_app/themes/styles/theme_colors.dart';
import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    splashColor: ThemeColors.primaryColor.shade100,
    fontFamily: Fonts.primary,
    colorScheme: ColorScheme.light(
        primary: ThemeColors.primaryColor,
        onPrimary: ThemeColors.white,
        primaryContainer: ThemeColors.white,
        onPrimaryContainer: ThemeColors.black,
        tertiaryContainer: ThemeColors.gray1,
        onTertiaryContainer: ThemeColors.black,
        error: ThemeColors.errorColor,
        errorContainer: ThemeColors.white
    ),
    hintColor: ThemeColors.gray4,
    iconButtonTheme: IconButtonThemeData(style: ButtonStyle(iconColor: WidgetStateProperty.all(ThemeColors.primaryColor))),
    textTheme:  const TextTheme(
      headlineSmall: TextStyle(fontWeight: FontWeight.w500)
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      backgroundColor: ThemeColors.primaryColor,
      foregroundColor: ThemeColors.white,
      fixedSize: const Size(double.maxFinite, 44),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      textStyle: buttonTextStyle,
    )),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
      foregroundColor: ThemeColors.black,
      fixedSize: const Size(double.maxFinite, 44),
      side: BorderSide(color: ThemeColors.black, width: 1.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      textStyle: buttonTextStyle,
    )),
);
