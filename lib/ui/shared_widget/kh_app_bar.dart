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
  final bool? notificationAction;
  final bool? cartAction;
  final bool? showLogo;
  final Color? systemNavigationBarColor;
  final Color? statusBarColor;
  final Brightness? statusBrightness;
  final bool _multiLine;

  const KhAppBar(
      {super.key,
      this.title,
      this.notificationAction,
      this.cartAction,
      this.showLogo,
      this.systemNavigationBarColor,
      this.statusBarColor,
      this.statusBrightness})
      : _multiLine = false;

  const KhAppBar.multiLine(
      {super.key,
      this.title,
      this.notificationAction,
      this.cartAction,
      this.showLogo,
      this.systemNavigationBarColor,
      this.statusBarColor,
      this.statusBrightness})
      : _multiLine = true;

  _openNotification(BuildContext context) {
    ToastMessage.show('Notification Clicked');
  }

  _onClickCart(BuildContext context) async {
    Navigator.of(context).pushNamed(Routes.cart);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
        systemOverlayStyle:
            SystemUiOverlayStyle(systemNavigationBarColor: systemNavigationBarColor, statusBarColor: statusBarColor, statusBarIconBrightness: statusBrightness),
        centerTitle: false,
        actions: [
          if (notificationAction ?? false)
            IconButton(
                onPressed: () => _openNotification(context),
                icon: SvgPicture.asset(
                  'assets/icons/notification_icon.svg',
                )),
          if (cartAction ?? false) IconButton(onPressed: () => _onClickCart(context), icon: SvgPicture.asset('assets/icons/cart_icon.svg')),
        ],
        titleSpacing: 20,
        toolbarHeight: kTextTabBarHeight,
        title: _multiLine
            ? SvgPicture.asset('assets/images/svg/app_header_logo.svg')
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (title != null) Text(title ?? '') else if (showLogo ?? false) SvgPicture.asset('assets/images/svg/app_header_logo.svg'),
                ],
              ),
        bottom: _multiLine ? const UserAppBarBottom() : null);
  }

  @override

  Size get preferredSize{
    var toolBarSize = _multiLine ? kToolbarHeight * 1.2 : kToolbarHeight;
    return  Size.fromHeight(toolBarSize);
  }
}

class UserAppBarBottom extends StatelessWidget implements PreferredSizeWidget {
  const UserAppBarBottom({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FutureBuilder<String?>(
        future: getUser(),
        builder: (context, snap) {
          return Container(
              padding: const EdgeInsets.only(left: 20, bottom: 10),
              alignment: Alignment.centerLeft,
              child: Text.rich(
                  TextSpan(
                      text: 'welcome'.tr(), children: [TextSpan(text: ' ${snap.data}', style: const TextStyle().copyWith(color: ThemeColors.primaryColor))]),
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)));
        });
  }

  Future<String> getUser() async {
    final loginUser = await AppSession().loginUser;

    if (loginUser != null) {
      final User user = User.fromJson(jsonDecode(loginUser));
      return user.fullName ?? "";
    }
    return '';
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(10);
}
