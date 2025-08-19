import 'package:permission_handler/permission_handler.dart';
import 'package:mhassoc_ui/constant/web_app_routes.dart';
import 'package:mhassoc_ui/themes/styles/theme_colors.dart';
import 'package:mhassoc_ui/themes/styles/typography.dart';
import 'package:mhassoc_ui/ui/shared_widget/dynamic_app_bar.dart';
import 'package:mhassoc_ui/ui/shared_widget/kh_app_bar.dart';
import 'package:mhassoc_ui/ui/shared_widget/web_view_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../constant/common_constants.dart';
import '../../constant/session_keys.dart';
import '../../utils/app_session_storage.dart';
import '../../utils/global_notifier.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<NavigationBarItem> _bottomNavigationTabs = [
    NavigationBarItem(
        iconUrl: 'assets/icons/home.svg',
        label: "home_screen.home".tr(),
        routeName: WebAppRoutes.dashboard),
    NavigationBarItem(
        iconUrl: 'assets/icons/notify_driver.svg',
        label: "home_screen.notify_driver".tr(),
        routeName: WebAppRoutes.coupon),
    NavigationBarItem(
        iconUrl: 'assets/icons/trips.svg',
        label: "home_screen.trip_quick_view".tr(),
        routeName: WebAppRoutes.offers),
    NavigationBarItem(
        iconUrl: 'assets/icons/request_view.svg',
        label: "home_screen.request_view".tr(),
        routeName: WebAppRoutes.support),
    //NavigationBarItem(iconUrl: 'assets/icons/orders.svg', label: "home_screen.payments".tr(),routeName:WebAppRoutes.payments),
    //NavigationBarItem(iconUrl: 'assets/icons/profile.svg', label: "home_screen.contract".tr(),routeName:WebAppRoutes.contract),
  ];
  int _currentTabIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTenentId();
  }
  Future<void> requestLocationPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      status = await Permission.location.request();
    }
  }
  Future<void> getTenentId() async {
    await requestLocationPermission();
    try
    {
      CommonConstants.tenantId =
      (await AppSessionStorage().getString(SessionKeys.tenantId))!;
    }catch(exc){
      // Failed to get tenant ID - continue with defaults
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KhAppBar(
        systemNavigationBarColor: ThemeColors.white,
        statusBarColor: ThemeColors.white,
        statusBrightness: Brightness.dark,
      ),
      /*bottomNavigationBar: ValueListenableBuilder<bool>(
          valueListenable: homeBottomBarVisible,
          builder: (context, value, _) {
            return value
                ? BottomNavigationBar(
                    onTap: (value) async {
                      if (_currentTabIndex == value) {
                        _bottomNavigationTabs[_currentTabIndex]
                            .key
                            .currentState
                            ?.loadWebView();
                      } else {
                        setState(() {
                          _currentTabIndex = value;
                        });
                      }
                    },
                    currentIndex: _currentTabIndex,
                    type: BottomNavigationBarType.fixed,
                    showUnselectedLabels: true,
                    selectedItemColor: ThemeColors.primaryColor,
                    enableFeedback: false,
                    unselectedItemColor: ThemeColors.gray4,
                    selectedLabelStyle:
                        menuTabTextStyle.copyWith(fontSize: 10),
                    unselectedLabelStyle: menuTabTextStyle,
                    items: List.generate(
                        value ? _bottomNavigationTabs.length : 2, (index) {
                      final navigationTab = _bottomNavigationTabs[index];
                      return BottomNavigationBarItem(
                          icon: SvgPicture.asset(
                            navigationTab.iconUrl,
                            colorFilter: index == _currentTabIndex
                                ? ColorFilter.mode(
                                    ThemeColors.primaryColor, BlendMode.srcIn)
                                : null,
                          ),
                          label: navigationTab.label);
                    }))
                : Container(height: 0);
          }),*/
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // DynamicAppBar(
          //   onBackButton: () {
          //     _bottomNavigationTabs[_currentTabIndex]
          //         .key
          //         .currentState
          //         ?.onPopInvoked(false, null);
          //   },
          // ),
          Flexible(
            child: WebViewContainer(
              key: _bottomNavigationTabs[_currentTabIndex].key,
              url: _bottomNavigationTabs[_currentTabIndex].routeName,
              enablePullToRefresh: true,
              onWebViewCreated: (controller) async {},
            ),
          ),
        ],
      ),
    );
  }
}

class NavigationBarItem {
  final String iconUrl;
  final String? label;
  final String routeName;
  final GlobalKey<WebViewContainerState> key = GlobalKey();

  NavigationBarItem(
      {required this.iconUrl, this.label, required this.routeName});
}
