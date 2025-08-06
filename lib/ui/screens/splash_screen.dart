import 'package:vendor_partner/constant/common_constants.dart';
import 'package:vendor_partner/routes.dart';
import 'package:vendor_partner/themes/styles/theme_colors.dart';
import 'package:vendor_partner/utils/app_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constant/session_keys.dart';
import '../../utils/app_session_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  Future<void> initState() async {
    CommonConstants.tenantId = (await AppSessionStorage().getString(SessionKeys.tenantId))!;
    print('CommonConstants.tenantId ${CommonConstants.tenantId}');
   Future.delayed(const Duration(seconds: 2),() async {
      final bool isLoggedIn = await AppSession().isLogin;
      final routeName = isLoggedIn ? Routes.home : Routes.sliderScreen;
      if(!mounted) return;
      Navigator.of(context).pushReplacementNamed(routeName);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light,statusBarColor: ThemeColors.primaryColor,systemStatusBarContrastEnforced: true,systemNavigationBarColor: ThemeColors.primaryColor));
    return Scaffold(
      body: Container(
        width: screenSize.width,
        color: ThemeColors.primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(flex: 2, child: Center(child: SvgPicture.asset('assets/images/svg/app_header_logo.svg',width: screenSize.width/2,)))
          ],
        ),
      ),
    );
  }
}
