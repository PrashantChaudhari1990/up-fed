import 'package:base_mobile_app/constant/web_app_routes.dart';
import 'package:base_mobile_app/routes.dart';
import 'package:base_mobile_app/themes/dart_theme.dart';
import 'package:base_mobile_app/themes/light_theme.dart';
import 'package:base_mobile_app/ui/screens/auth/sign_up_screen.dart';
import 'package:base_mobile_app/ui/screens/slider/slider_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'ui/screens/auth/login_screen.dart';
import 'ui/screens/auth/otp_verification_screen.dart';
import 'ui/screens/auth/validate_pin_screen.dart';
import 'ui/screens/home_screen.dart';
import 'ui/screens/splash_screen.dart';
import 'ui/screens/web_view_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        initialRoute: Routes.initial,
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        routes: {
          Routes.initial : (context) =>  const SplashScreen(),
          Routes.sliderScreen:(context)=> const SliderScreen(),
          Routes.home : (context)=>  const HomeScreen(),
          Routes.login : (context)=>  const LoginScreen(),
          Routes.signUp : (context)=>   SignUpScreen(),
          Routes.otpVerification : (context)=>  const OtpVerificationScreen(),
          Routes.validatePin : (context)=>  const ValidatePinScreen(),
          Routes.cart:(context)=>  const WebViewScreen(routeName: WebAppRoutes.cartScreen,title: "Cart",),
          Routes.category:(context)=>  const WebViewScreen(routeName: WebAppRoutes.categoryScreen,title: "Category",showCart: true,showNotification: true,),
          Routes.pendingVerification:(context)=>  const WebViewScreen(routeName: WebAppRoutes.pendingVerification,showAppBar: false,showCart: true,showNotification: true,),
        }
    );
  }
}
