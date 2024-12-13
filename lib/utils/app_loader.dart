import 'package:base_mobile_app/app.dart';
import 'package:flutter/material.dart';

class AppLoader {
  static final AppLoader _instance = AppLoader._internal();
  factory AppLoader() => _instance;
  AppLoader._internal();

  static show(){
    if(MyApp.navigatorKey.currentContext != null){
      showDialog(
          context: MyApp.navigatorKey.currentContext!, builder: (context){
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: PopScope(
              canPop: false,
              child: Center(
                child: SizedBox(
                    width: MediaQuery.of(context).size.width/2,
                    child: FittedBox(child: Image.asset('assets/images/loader.gif',))),
              )),
        );
      });
    }
  }

  static hide(){
    if(MyApp.navigatorKey.currentContext != null) {
      Navigator.of(MyApp.navigatorKey.currentContext!).pop();
    }
  }
}