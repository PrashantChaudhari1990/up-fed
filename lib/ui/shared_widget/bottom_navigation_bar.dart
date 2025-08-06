import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../themes/styles/theme_colors.dart';
import '../../themes/styles/typography.dart';

class BottomNavigationMenu extends StatefulWidget {
  const BottomNavigationMenu({super.key});

  @override
  State<BottomNavigationMenu> createState() => _BottomNavigationMenuState();
}

class _BottomNavigationMenuState extends State<BottomNavigationMenu> {
  final List<Map<String, String>> _bottomNavigationTabs = [
    {
      "iconUrl": 'assets/icons/home.svg',
      "label": "home_screen.home".tr(),
      "routeName": ""
    },
    {
      "iconUrl": 'assets/icons/credits.svg',
      "label": "home_screen.credit".tr(),
      "routeName": ""
    },
    {
      "iconUrl": 'assets/icons/orders.svg',
      "label": "home_screen.orders".tr(),
      "routeName": "/category"
    },
    {
      "iconUrl": 'assets/icons/profile.svg',
      "label": "home_screen.profile".tr(),
      "routeName": ""
    }
  ];

  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
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
        selectedLabelStyle:
            menuTabTextStyle.copyWith(fontWeight: FontWeight.bold),
        unselectedLabelStyle: menuTabTextStyle,
        items: List.generate(_bottomNavigationTabs.length, (index) {
          final navigationTab = _bottomNavigationTabs[index];
          return BottomNavigationBarItem(
              icon: SvgPicture.asset(
                navigationTab['iconUrl']!,
                colorFilter: index == _currentTabIndex
                    ? ColorFilter.mode(
                        ThemeColors.primaryColor, BlendMode.srcIn)
                    : null,
              ),
              label: navigationTab['label']);
        }));
  }
}
