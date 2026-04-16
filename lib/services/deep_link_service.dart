import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:mhassoc_ui/utils/webview_controller_utils.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../config/server_config.dart';

class DeepLinkService {
  static final DeepLinkService _instance = DeepLinkService._internal();
  factory DeepLinkService() => _instance;
  DeepLinkService._internal();

  final AppLinks _appLinks = AppLinks();

  /// Stores the pending deep link path (e.g., "/product/123")
  String? _pendingDeepLinkPath;

  /// Get and clear the pending deep link path
  String? consumePendingDeepLinkPath() {
    final path = _pendingDeepLinkPath;
    _pendingDeepLinkPath = null;
    return path;
  }

  /// Check if there's a pending deep link
  bool get hasPendingDeepLink => _pendingDeepLinkPath != null;

  /// Initialize the deep link service. Call this once on app startup.
  Future<void> init() async {
    // Case 1: App was CLOSED — opened via deep link (cold start)
    try {
      final initialUri = await _appLinks.getInitialLink();
      if (initialUri != null) {
        _handleLink(initialUri);
      }
    } catch (e) {
      debugPrint('Deep link cold start error: $e');
    }

    // Case 2: App was in BACKGROUND or FOREGROUND — link clicked
    _appLinks.uriLinkStream.listen(
      (uri) => _handleLink(uri),
      onError: (e) => debugPrint('Deep link stream error: $e'),
    );
  }

  void _handleLink(Uri uri) {
    debugPrint('Deep link received: $uri');

    // Extract path from incoming link
    // e.g. https://bttoa-connect.oorjaa.tech/product/123?color=red
    final path = uri.path; // /product/123
    final query = uri.query; // color=red

    // Build the full path with query string
    final fullPath = query.isNotEmpty ? '$path?$query' : path;

    debugPrint('Deep link path: $fullPath');

    // Check if WebView controller exists (app is already running with HomeScreen)
    if (WebViewControllerUtils.controller != null) {
      // App is already running, load URL directly in WebView
      _loadUrlInWebView(fullPath);
    } else {
      // App is starting up, store the path for later
      _pendingDeepLinkPath = fullPath;
      debugPrint('Stored pending deep link path: $fullPath');
    }
  }

  void _loadUrlInWebView(String path) {
    final controller = WebViewControllerUtils.controller;
    if (controller == null) {
      debugPrint('WebView controller not available');
      return;
    }

    final fullUrl = '${environment.webAppUrl}$path';
    debugPrint('Loading deep link URL in WebView: $fullUrl');

    controller.loadUrl(urlRequest: URLRequest(url: WebUri(fullUrl)));
  }
}
