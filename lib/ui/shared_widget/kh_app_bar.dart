import 'package:kh_dealer_app/constant/session_keys.dart';
import 'package:kh_dealer_app/routes.dart';
import 'package:kh_dealer_app/utils/toast_message.dart';
import 'package:kh_dealer_app/utils/webview_controller_utils.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:restart_app/restart_app.dart';

import '../../utils/app_session.dart';
class KhAppBar extends StatelessWidget implements PreferredSizeWidget  {
  final String? title;
  final bool? notificationAction;
  final bool? cartAction;
  final bool? showLogo;
  final Color? systemNavigationBarColor;

  const KhAppBar({super.key, this.title, this.notificationAction, this.cartAction,this.showLogo,this.systemNavigationBarColor});

  _openNotification(BuildContext context){
    ToastMessage.show('Notification Clicked');
  }

  _onClickCart(BuildContext context) async {
    Navigator.of(context).pushNamed(Routes.cart);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(systemNavigationBarColor: systemNavigationBarColor),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if(title != null)
              Text(title??'')
            else
            Text("welcome",style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),).tr(),
            if(showLogo??false)
            SvgPicture.asset('assets/images/svg/app_header_logo.svg'),
            Row(
              children: [
                if(notificationAction??false)
                IconButton(onPressed: ()=>_openNotification(context), icon: SvgPicture.asset('assets/icons/notification_icon.svg',)),
                if(cartAction??false)
                IconButton(onPressed: ()=>_onClickCart(context),icon: SvgPicture.asset('assets/icons/cart_icon.svg')),
              ],
            )
          ],
        )
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
