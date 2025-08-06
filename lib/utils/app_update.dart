import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';

class AppUpdate {
  checkForForceUpdate() {
    InAppUpdate.checkForUpdate().then((result) {
      if (result.updateAvailability == UpdateAvailability.updateAvailable) {
        debugPrint('Update Available');
      }
    });
  }
}
