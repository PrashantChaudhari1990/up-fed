import 'package:kh_dealer_app/themes/styles/theme_colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastMessage{
  static show(String? message){
    if(message != null){
      Fluttertoast.showToast(msg: message,toastLength: Toast.LENGTH_LONG);
    }
  }
}