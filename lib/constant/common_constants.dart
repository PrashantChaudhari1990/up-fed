import 'dart:io';

abstract class CommonConstants {
  static get xVisibilityScope {
    if (Platform.isAndroid) {
      return "vas-user-app";
    } else if (Platform.isIOS) {
      return "vas-user-app";
    } else {
      return '';
    }
  }

  static String tenantId = '3';

  static String testingWebUrlIp = "192.168.1.109";
}
