import 'package:supervisor_ui/app.dart';
import 'package:flutter/material.dart';

class AppLoader {
  static final AppLoader _instance = AppLoader._internal();
  factory AppLoader() => _instance;
  AppLoader._internal();
  bool _loaderVisible = false;

  show() {
    if (MyApp.navigatorKey.currentContext != null && !_loaderVisible) {
      _loaderVisible = true;
      showDialog(
          context: MyApp.navigatorKey.currentContext!,
          builder: (context) {
            return Scaffold(
              backgroundColor: Colors.transparent,
              body: PopScope(
                  canPop: false,
                  child: Center(
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: Image.asset(
                          'assets/images/loader.gif',
                        )),
                  )),
            );
          });
    }
  }

  hide() {
    if (_loaderVisible) {
      if (MyApp.navigatorKey.currentContext != null) {
        _loaderVisible = false;
        Navigator.of(MyApp.navigatorKey.currentContext!).pop();
      }
    }
  }
}
