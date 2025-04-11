import 'package:vendor_partner/themes/styles/fonts.dart';
import 'package:vendor_partner/themes/styles/theme_colors.dart';
import 'package:flutter/material.dart';

//flutter theme

TextStyle buttonTextStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.w700,fontFamily: Fonts.primary );

///[inputHintStyle] used for hint text of input field.
TextStyle inputHintStyle = TextStyle(fontWeight: FontWeight.w400,fontSize: 14,fontFamily: Fonts.primary,color: ThemeColors.gray3);

///[inputTextStyle] used for entered text in input field
TextStyle inputTextStyle =  TextStyle(fontWeight: FontWeight.w400,fontSize: 14,fontFamily: Fonts.primary);

TextStyle linkTextStyleSmall =  TextStyle(fontWeight: FontWeight.w600,fontSize: 14,fontFamily: Fonts.primary,color: ThemeColors.linkColor,decoration: TextDecoration.underline,decorationColor: ThemeColors.linkColor,);

TextStyle menuTabTextStyle =  TextStyle(fontWeight: FontWeight.w400,fontSize: 14,fontFamily: Fonts.primary,);
