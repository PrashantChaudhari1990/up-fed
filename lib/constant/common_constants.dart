import 'dart:io';
abstract class CommonConstants{

  static get xVisibilityScope{
    if(Platform.isAndroid){
      return "VENDOR_APP";
    }else if(Platform.isIOS){
      return "VENDOR_APP";
    }else{
      return '';
    }
  }
  static const xTenantId = 1;

  static String testingWebUrlIp = "192.168.1.109";
}