import 'package:base_mobile_app/constant/session_keys.dart';
import 'package:base_mobile_app/utils/app_session_storage.dart';

class AppSession {
  static final AppSession _instance = AppSession._internal();
  factory AppSession() => _instance;
  AppSession._internal();

  final _sessionStorage = AppSessionStorage();

  Future<bool> get isLogin async{
    return await _sessionStorage.getBool(SessionKeys.isLogin);
  }

  set isLogin(value) {
    _sessionStorage.setBool(SessionKeys.isLogin,value);
  }

  Future<String?> get loginUser async{
    return await _sessionStorage.getString(SessionKeys.user);
  }

  set loginUser(value) {
    _sessionStorage.setString(SessionKeys.user,value);
  }

}