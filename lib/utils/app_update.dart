import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdate {
  static checkForForceUpdate() async {
    try {
      if(defaultTargetPlatform == TargetPlatform.android){
        InAppUpdate.checkForUpdate().then((result)  {
          if (result.updateAvailability == UpdateAvailability.updateAvailable) {
            debugPrint('Update Available');
            InAppUpdate.performImmediateUpdate();
          }
        });
      }else if(defaultTargetPlatform == TargetPlatform.iOS){
        Dio dio = Dio();
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        final currentVersion = packageInfo.version;
        final packageName = packageInfo.packageName;
        final response = await dio.get('https://itunes.apple.com/lookup?bundleId=$packageName');
        if (response.statusCode == 200 && response.data != null) {
          final json = jsonDecode(response.data);
            final results = json['results'] as List;
            if (results.isNotEmpty) {
              final latestVersion = results[0]['version'] as String?;
              final trackingUrl = results[0]['trackViewUrl'] as String?;
             if(latestVersion != null && trackingUrl != null  && currentVersion != latestVersion){
               final url = Uri.parse(trackingUrl);
               if(await canLaunchUrl(url)){
                 launchUrl(url);
               }
             }
          }
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
