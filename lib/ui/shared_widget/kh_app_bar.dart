import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    return  const Size.fromHeight(0);
  }
}
