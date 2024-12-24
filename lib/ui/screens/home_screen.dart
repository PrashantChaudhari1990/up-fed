import 'package:base_mobile_app/constant/web_app_routes.dart';
import 'package:base_mobile_app/themes/styles/theme_colors.dart';
import 'package:base_mobile_app/themes/styles/typography.dart';
import 'package:base_mobile_app/ui/shared_widget/kh_app_bar.dart';
import 'package:base_mobile_app/ui/shared_widget/web_view_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';

import '../../constant/session_keys.dart';
import '../../utils/app_session_storage.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> _bottomNavigationTabs = [
    {"iconUrl": 'assets/icons/home.svg', "label": "home_screen.home".tr(),"routeName":WebAppRoutes.dashboard},
    {"iconUrl": 'assets/icons/credits.svg', "label": "home_screen.credit".tr(),"routeName":WebAppRoutes.credit},
    {"iconUrl": 'assets/icons/orders.svg', "label": "home_screen.orders".tr(),"routeName":WebAppRoutes.orders},
    {"iconUrl": 'assets/icons/profile.svg', "label": "home_screen.profile".tr(),"routeName":WebAppRoutes.profile}
  ];

   int _currentTabIndex = 0;
   InAppWebViewController? _inAppWebViewController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: const KhAppBar(showLogo: true,notificationAction: true,cartAction: true,),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) async {
          setState(() {
            _currentTabIndex = value;
          });
        },
        currentIndex: _currentTabIndex,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          selectedItemColor: ThemeColors.primaryColor,
          enableFeedback: false,
          unselectedItemColor: ThemeColors.gray4,
          selectedLabelStyle: menuTabTextStyle.copyWith(fontWeight: FontWeight.bold),
          unselectedLabelStyle: menuTabTextStyle,
          items: List.generate(_bottomNavigationTabs.length, (index){
            final navigationTab = _bottomNavigationTabs[index];
            return BottomNavigationBarItem(icon: SvgPicture.asset(navigationTab['iconUrl']!,
              colorFilter: index == _currentTabIndex ? ColorFilter.mode(ThemeColors.primaryColor, BlendMode.srcIn):null,),
                label: navigationTab['label']);
          })
      ),
      body: WebViewContainer(
          url: _bottomNavigationTabs[_currentTabIndex]['routeName'],
        enablePullToRefresh: true,
        onWebViewCreated: (controller) async {
          final session = await AppSessionStorage().getString(SessionKeys.user);
          await controller.webStorage.localStorage.setItem(key: SessionKeys.user, value: session);
          _inAppWebViewController = controller;
        },
      ),
    );
  }
}
