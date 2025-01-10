import 'package:kh_dealer_app/constant/session_keys.dart';
import 'package:kh_dealer_app/utils/app_session_storage.dart';

class AppSession {
  static final AppSession _instance = AppSession._internal();
  factory AppSession() => _instance;
  AppSession._internal();

  final _sessionStorage = AppSessionStorage();

  Future<bool> get isLogin async{
    return (await loginUser) != null;
  }

  Future<String?> get loginUser async{
    return await _sessionStorage.getString(SessionKeys.user);
  }

  set loginUser(value) {
    if(value != null){
      _sessionStorage.setString(SessionKeys.user,value);
    }else{
      _sessionStorage.remove(SessionKeys.user);
    }
  }

}