import 'package:base_mobile_app/routes.dart';
import 'package:base_mobile_app/themes/styles/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../config/notification_config.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    printFcmToken();
    Future.delayed(const Duration(seconds: 2),()=>{
      if(mounted)
      Navigator.of(context).pushReplacementNamed(Routes.sliderScreen)
    });
    super.initState();
  }
  printFcmToken() async {
    print(await NotificationConfig.fcmToken);

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
            Flexible(flex: 2, child: Center(child: SvgPicture.asset('assets/images/svg/splash_screen_logo.svg',width: screenSize.width/2,)))
          ],
        ),
      ),
    );
  }
}
