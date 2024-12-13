import 'dart:convert';
import 'package:base_mobile_app/constant/session_keys.dart';
import 'package:base_mobile_app/themes/styles/theme_colors.dart';
import 'package:base_mobile_app/utils/app_session_storage.dart';
import 'package:flutter/services.dart';
import 'package:restart_app/restart_app.dart';

class ThemeColorsConfig{
  final _sessionStorage = AppSessionStorage();
  final String _themeSessionKey = "appThemeColors";

  Future fetch() async {
    final String themeName = await _sessionStorage.getString(_themeSessionKey) ?? SessionKeys.appThemeColors;
    final loadedThemeString = await rootBundle.loadString('assets/themes/$themeName.json').catchError((e){
      return "";
    });
    final themeColors = jsonDecode(loadedThemeString);
    ThemeColors.fromJson(themeColors);
  }

  changeTheme(String themeName){
    _sessionStorage.setString(_themeSessionKey,themeName);
    fetch().then((value){
      Restart.restartApp();
    });
  }
}