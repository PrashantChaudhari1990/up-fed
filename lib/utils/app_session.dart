import 'package:vendor_partner/constant/session_keys.dart';
import 'package:vendor_partner/utils/app_session_storage.dart';

class AppSession {
  static final AppSession _instance = AppSession._internal();
  factory AppSession() => _instance;
  AppSession._internal();

  final _sessionStorage = AppSessionStorage();

  Future<bool> get isLogin async {
    return (await loginUser) != null;
  }

  Future<String?> get loginUser async {
    return await _sessionStorage.getString(SessionKeys.user);
  }

  set loginUser(value) {
    if (value != null) {
      _sessionStorage.setString(SessionKeys.user, value);
    } else {
      _sessionStorage.remove(SessionKeys.user);
    }
  }

  Future<String?> get tenantId async {
    return await _sessionStorage.getString(SessionKeys.tenantId);
  }

  set tenantId(value) {
    if (value != null) {
      _sessionStorage.setString(SessionKeys.tenantId, value);
    } else {
      _sessionStorage.remove(SessionKeys.tenantId);
    }
  }
}
