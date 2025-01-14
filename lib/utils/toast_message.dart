import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastMessage{
  static show(String? message){
    if(message != null){
      final gravity = defaultTargetPlatform == TargetPlatform.iOS ?  ToastGravity.TOP : ToastGravity.BOTTOM;
      Fluttertoast.showToast(msg: message,toastLength: Toast.LENGTH_LONG,gravity: gravity);
    }
  }
}