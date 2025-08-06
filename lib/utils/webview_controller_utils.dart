import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewControllerUtils {
  static InAppWebViewController? _inAppWebViewController;

  static set controller(InAppWebViewController? value) {
    _inAppWebViewController = value;
  }

  static InAppWebViewController? get controller => _inAppWebViewController;
}
