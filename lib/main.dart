import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:vendor_partner/config/theme_colors_config.dart';
import 'package:vendor_partner/services/interceptor_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'app.dart';
import 'config/localization_config.dart';
import 'config/notification_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeColorsConfig().fetch();
  await Firebase.initializeApp();
  NotificationConfig().setupFirebaseMessaging();
  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(true);
  }
  await EasyLocalization.ensureInitialized();
  InterceptorService().initialize();
  runApp(EasyLocalization(
      path: LocalizationConfig.translationPath,
      supportedLocales: LocalizationConfig.supportedLocales,
      fallbackLocale: LocalizationConfig.supportedLocales.first,
      child: const MyApp()));
}
