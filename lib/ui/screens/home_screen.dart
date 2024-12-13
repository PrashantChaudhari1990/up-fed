import 'package:base_mobile_app/constant/session_keys.dart';
import 'package:base_mobile_app/routes.dart';
import 'package:base_mobile_app/themes/styles/theme_colors.dart';
import 'package:base_mobile_app/themes/styles/typography.dart';
import 'package:base_mobile_app/ui/shared_widget/web_view_container.dart';
import 'package:base_mobile_app/utils/app_session_storage.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_svg/svg.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> _bottomNavigationTabs = [
    {"iconUrl": 'assets/icons/home.svg', "label": "home_screen.home".tr(),"routeName":"/profile/user"},
    {"iconUrl": 'assets/icons/credits.svg', "label": "home_screen.credit".tr(),"routeName":"/profile/user"},
    {"iconUrl": 'assets/icons/orders.svg', "label": "home_screen.orders".tr(),"routeName":"/profile/user"},
    {"iconUrl": 'assets/icons/profile.svg', "label": "home_screen.profile".tr(),"routeName":"/profile/user"}
  ];

   int _currentTabIndex = 0;
   InAppWebViewController? _inAppWebViewController;
  _openNotification(){
    AppSessionStorage().remove(SessionKeys.user);
    _inAppWebViewController?.webStorage.localStorage.clear();
    debugPrint("On open notification icon click");
  }

  _onClickUserIcon() async {
   Navigator.of(context).pushNamed(Routes.profile);
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("welcome",style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),).tr(),
            SvgPicture.asset('assets/images/svg/app_header_logo.svg'),
            Row(
              children: [
                IconButton(onPressed: _openNotification, icon: SvgPicture.asset('assets/icons/notification_icon.svg')),
                IconButton(onPressed: _onClickUserIcon,icon: SvgPicture.asset('assets/icons/user_icon.svg')),
              ],
            )
          ],
        )
      ),
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
        onWebViewCreated: (controller) async {
            _inAppWebViewController = controller;
        },
      ),
    );
  }
}
