import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:mhassoc_ui/config/server_config.dart';

import '../../routes.dart';
import '../../themes/styles/theme_colors.dart';
import '../../utils/app_session.dart';
import '../../utils/app_update.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  initState() {
    try {
      checkForUpdate();
      checkUpdateForIOS();
    } catch(ex) {}
    Future.delayed(const Duration(seconds: 2), () async {
      final bool isLoggedIn = await AppSession().isLogin;
      final routeName = isLoggedIn ? Routes.home : Routes.login;
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(routeName);
    });
    super.initState();
  }

  void checkForUpdate() {
    if(environment.appUpdate) {
      AppUpdate().checkForForceUpdate();
    }
  }

  Future<void> checkUpdateForIOS() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (defaultTargetPlatform == TargetPlatform.iOS && (packageInfo.version != '8.0.0')) {
      AppUpdate().gotoIOSStore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: ThemeColors.primaryColor,
        systemStatusBarContrastEnforced: true,
        systemNavigationBarColor: ThemeColors.primaryColor));
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: screenSize.width,
          //color: ThemeColors.primaryColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  flex: 2,
                  child: Center(
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width / 4,
                          height: MediaQuery.of(context).size.width / 4,
                          child: Image.asset(
                            'assets/images/png/ic_launcher.png',
                          )),))
            ],
          ),
        ),
      ),
    );
  }
}
