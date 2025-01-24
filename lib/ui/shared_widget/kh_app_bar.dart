import 'dart:convert';
import 'package:kh_dealer_app/models/user.dart';
import 'package:kh_dealer_app/routes.dart';
import 'package:kh_dealer_app/utils/toast_message.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import '../../themes/styles/theme_colors.dart';
import '../../utils/app_session.dart';

class KhAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Color? systemNavigationBarColor;
  final Color? statusBarColor;
  final Brightness? statusBrightness;

  const KhAppBar(
      {super.key,
      this.title,
       this.systemNavigationBarColor,
      this.statusBarColor,
      this.statusBrightness});

  @override
  Widget build(BuildContext context) {

    return AppBar(
        systemOverlayStyle:
            SystemUiOverlayStyle(systemNavigationBarColor: systemNavigationBarColor, statusBarColor: statusBarColor, statusBarIconBrightness: statusBrightness),
        centerTitle: false,
        titleSpacing: 20,
        toolbarHeight: 0,
        title: Text(title ?? ''));
  }

  @override

  Size get preferredSize{
    return  Size.fromHeight(0);
  }
}
