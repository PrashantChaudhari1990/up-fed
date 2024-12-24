import 'dart:io';
abstract class CommonConstants{

  static get xVisibilityScope{
    if(Platform.isAndroid){
      return "kh-android-customer-app";
    }else if(Platform.isIOS){
      return "kh-ios-customer-app";
    }else{
      return '';
    }
  }
  static const xTenantId = 1;

  static String testingWebUrlIp = "192.168.1.109";
}