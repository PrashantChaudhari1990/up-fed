import 'dart:io';

abstract class CommonConstants {
  static get xVisibilityScope {
    if (Platform.isAndroid) {
      return "SUPERVISOR";
    } else if (Platform.isIOS) {
      return "SUPERVISOR";
    } else {
      return '';
    }
  }

  static String tenantId = '';

  static String testingWebUrlIp = "192.168.1.109";
}
