import 'dart:io';
abstract class CommonConstants{

  static get xVisibilityScope{
    if(Platform.isAndroid){
      return "TMS_WEB";
    }else if(Platform.isIOS){
      return "TMS_WEB";
    }else{
      return '';
    }
  }
  static const xTenantId = 1;

  static String testingWebUrlIp = "192.168.1.109";
}