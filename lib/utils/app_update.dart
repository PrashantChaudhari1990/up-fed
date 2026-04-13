import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:mhassoc_ui/config/server_config.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdate {
  checkForForceUpdate() {
    if (!Platform.isAndroid) {
      return;
    }
    try {
      InAppUpdate.checkForUpdate().then((result) {
        if (result.updateAvailability == UpdateAvailability.updateAvailable) {
          InAppUpdate.performImmediateUpdate();
          debugPrint('Update Available');
        }
      }).catchError((e) {
        debugPrint(e.toString());
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> gotoIOSStore() async {
    const appStoreUrl = "https://apps.apple.com/in/app/mh-federation/id6751527920";
    if(environment.appUpdate) {
      if (await canLaunchUrl(Uri.parse(appStoreUrl))) {
        await launchUrl(Uri.parse(appStoreUrl));
      } else {
        throw 'Could not launch $appStoreUrl';
      }
    }
  }
}
