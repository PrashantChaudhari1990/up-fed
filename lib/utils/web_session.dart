import 'package:flutter_inappwebview/flutter_inappwebview.dart';

extension WebSession on InAppWebViewController {
  ///[getLocalStorageValue] is used to get data from web view local storage using key.
  Future<dynamic> getLocalStorageValue(String key) async {
    return await webStorage.localStorage.getItem(key: key);
  }

  ///[setLocalStorageValue] is used to set data in web view local storage.
  Future<void> setLocalStorageValue(String key, dynamic value) async {
    webStorage.localStorage.setItem(key: key, value: value);
  }
}
