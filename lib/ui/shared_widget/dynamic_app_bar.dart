import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vendor_partner/config/server_config.dart';
import 'package:vendor_partner/constant/web_app_routes.dart';
import 'package:vendor_partner/utils/global_notifier.dart';
import '../../models/user.dart';
import '../../themes/styles/theme_colors.dart';
import '../../utils/app_session.dart';
import '../../utils/toast_message.dart';
import '../../utils/webview_controller_utils.dart';

class DynamicAppBar extends StatelessWidget {
  final void Function()? onBackButton;

  const DynamicAppBar({super.key, this.onBackButton});

  final Widget _emptyBox = const SizedBox(width: 0,height: 0,);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ValueListenableBuilder(
      valueListenable: appBarVisibleNotifier,
      builder: (context, appBarVisible, _) {
        if (!appBarVisible) return _emptyBox;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: ValueListenableBuilder(
                  valueListenable: titleAppBarNotifier,
                  builder: (context, isTitleAppBar, _) {
                    return Visibility(
                      visible: isTitleAppBar,
                      replacement: _buildLogoAndWelcomeSection(theme),
                      child: _buildBackButtonAndTitle(theme),
                    );
                  },
                ),
              ),
              _buildActionButtons(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLogoAndWelcomeSection(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset('assets/images/svg/app_header_logo.svg'),
        ValueListenableBuilder(
          valueListenable: userNameVisibleNotifier,
          builder: (context, isVisible, _) {
            if (!isVisible) return _emptyBox;

            return FutureBuilder<String?>(
              future: getUser(),
              builder: (context, snapshot) {
                final userName = snapshot.data;

                return Container(
                  padding: const EdgeInsets.only(top: 5),
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text.rich(
                      TextSpan(
                        text: 'welcome'.tr(),
                        style: const TextStyle(fontSize: 14),
                        children: [
                          TextSpan(
                            text: ' $userName',
                            style: const TextStyle().copyWith(color: ThemeColors.primaryColor),
                          ),
                        ],
                      ),
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget _buildBackButtonAndTitle(ThemeData theme) {
    return ValueListenableBuilder(
      valueListenable: allowBackNotifier,
      builder: (context, isBackAllowed, _) {
        return Row(
          children: [
            if (isBackAllowed)
              InkWell(
                onTap: onBackButton,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Icon(
                    Icons.arrow_back,
                    color: ThemeColors.primaryColor,
                  ),
                ),
              ),
            ValueListenableBuilder(
              valueListenable: titleVisibleNotifier,
              builder: (context, isTitleVisible, _) {
                if (!isTitleVisible) return _emptyBox;

                return ValueListenableBuilder(
                  valueListenable: titleNotifier,
                  builder: (context, title, _) {
                    return Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        ValueListenableBuilder(
          valueListenable: notificationVisibleNotifier,
          builder: (context, isVisible, _) {
            if (!isVisible) return _emptyBox;

            return IconButton(
              onPressed: () => _openNotification(context),
              icon: SvgPicture.asset('assets/icons/notification_icon.svg'),
            );
          },
        ),
        ValueListenableBuilder(
          valueListenable: settingIconVisibleNotifier,
          builder: (context, isVisible, _) {
            if (!isVisible) return _emptyBox;

            return IconButton(
              onPressed: () => _onClickCart(context),
              icon: SvgPicture.asset('assets/icons/user_icon.svg'),
            );
          },
        ),
      ],
    );
  }


  _openNotification(BuildContext context) {
    ToastMessage.show('Notification Clicked');
  }

  _onClickCart(BuildContext context) async {
    WebViewControllerUtils.controller?.loadUrl(urlRequest: URLRequest(url: WebUri(environment.webAppUrl+WebAppRoutes.reviewData)));
  }

  Future<String> getUser() async {
    final loginUser = await AppSession().loginUser;

    if (loginUser != null) {
      final User user = User.fromJson(jsonDecode(loginUser));
      return user.firstName ?? "";
    }
    return '';
  }
}
