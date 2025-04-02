import 'package:kh_dealer_app/constant/web_app_routes.dart';
import 'package:kh_dealer_app/themes/styles/theme_colors.dart';
import 'package:kh_dealer_app/themes/styles/typography.dart';
import 'package:kh_dealer_app/ui/shared_widget/dynamic_app_bar.dart';
import 'package:kh_dealer_app/ui/shared_widget/kh_app_bar.dart';
import 'package:kh_dealer_app/ui/shared_widget/web_view_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../utils/global_notifier.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final List<NavigationBarItem> _bottomNavigationTabs = [
    NavigationBarItem(iconUrl: 'assets/icons/home.svg', label: "home_screen.home".tr(),routeName:WebAppRoutes.dashboard),
    NavigationBarItem(iconUrl: 'assets/icons/assets.svg', label: "home_screen.vehicle".tr(),routeName:WebAppRoutes.vehicleModelsList),
    NavigationBarItem(iconUrl: 'assets/icons/trips.svg', label: "home_screen.trips".tr(),routeName:WebAppRoutes.trips),
    NavigationBarItem(iconUrl: 'assets/icons/invoice.svg', label: "home_screen.invoiceUpload".tr(),routeName:WebAppRoutes.invoiceUpload),
    //NavigationBarItem(iconUrl: 'assets/icons/orders.svg', label: "home_screen.payments".tr(),routeName:WebAppRoutes.payments),
    //NavigationBarItem(iconUrl: 'assets/icons/profile.svg', label: "home_screen.contract".tr(),routeName:WebAppRoutes.contract),
  ];
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      KhAppBar(systemNavigationBarColor: ThemeColors.white,statusBarColor: ThemeColors.white,statusBrightness: Brightness.dark,),
      bottomNavigationBar: ValueListenableBuilder<bool>(
        valueListenable: homeBottomBarVisible,
        builder: (context,value,_) {
          return value ? BottomNavigationBar(
            onTap: (value) async {
              if(_currentTabIndex == value){
                _bottomNavigationTabs[_currentTabIndex].key.currentState?.loadWebView();
              }else{
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
              selectedLabelStyle: menuTabTextStyle.copyWith(fontWeight: FontWeight.bold),
              unselectedLabelStyle: menuTabTextStyle,
              items: List.generate(value ? _bottomNavigationTabs.length:2, (index){
                final navigationTab = _bottomNavigationTabs[index];
                return BottomNavigationBarItem(icon: SvgPicture.asset(navigationTab.iconUrl,
                  colorFilter: index == _currentTabIndex ? ColorFilter.mode(ThemeColors.primaryColor, BlendMode.srcIn):null,),
                    label: navigationTab.label);
              })
          ):Container(height: 0);
        }
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DynamicAppBar(
            onBackButton: (){
              _bottomNavigationTabs[_currentTabIndex].key.currentState?.onPopInvoked(false,null);
            },
          ),
          Flexible(
            child: WebViewContainer(
              key: _bottomNavigationTabs[_currentTabIndex].key,
              url: _bottomNavigationTabs[_currentTabIndex].routeName,
              enablePullToRefresh: true,
              onWebViewCreated: (controller) async {
              },
            ),
          ),
        ],
      ),
    );
  }
}


class NavigationBarItem{
  final String iconUrl;
  final String? label;
  final String routeName;
  final GlobalKey<WebViewContainerState> key = GlobalKey();

  NavigationBarItem({required this.iconUrl, this.label,required this.routeName});
}