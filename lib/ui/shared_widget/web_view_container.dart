import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mhassoc_ui/routes.dart';
import 'package:mhassoc_ui/themes/styles/theme_colors.dart';
import 'package:mhassoc_ui/utils/app_loader.dart';
import 'package:mhassoc_ui/utils/toast_message.dart';
import 'package:mhassoc_ui/utils/webview_controller_utils.dart';
import 'package:mhassoc_ui/web_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_file/open_file.dart';
import 'package:http/http.dart' as http;
import '../../config/server_config.dart';
import '../../constant/session_keys.dart';
import '../../constant/web_handler_names.dart';
import '../../constant/common_constants.dart';
import '../../utils/app_session_storage.dart';
import '../../utils/global_notifier.dart';

class WebViewContainer extends StatefulWidget {
  final String? url;
  final void Function(InAppWebViewController)? onWebViewCreated;
  final bool enablePullToRefresh;

  const WebViewContainer(
      {super.key,
        this.url,
        this.onWebViewCreated,
        this.enablePullToRefresh = false});

  @override
  State<WebViewContainer> createState() => WebViewContainerState();
}

class WebViewContainerState extends State<WebViewContainer> {
  final String _customSchema = 'bttoa:';


  List<String> allowDomainToOpenInApp = [
    "https://api.razorpay.com/",
    "oorjaa.tech",
    "datashastra.io"
  ];

  PullToRefreshController? _pullToRefreshController;
  InAppWebViewController? _inAppWebViewController;

  DateTime? backPressTime;

  InAppWebViewSettings inAppWebViewSettings = InAppWebViewSettings(
      useShouldOverrideUrlLoading: true,
      cacheEnabled: true,
      cacheMode: CacheMode.LOAD_NO_CACHE,
      supportZoom: false,
      supportMultipleWindows: false,
      clearCache: false,
      clearSessionCache: true,
      incognito: false,
      allowsInlineMediaPlayback: true,
      isInspectable: kDebugMode,
      mediaPlaybackRequiresUserGesture: false,
      iframeAllow: "camera; microphone",
      iframeAllowFullscreen: false,
      // File upload support
      allowFileAccess: true,
      allowFileAccessFromFileURLs: true,
      allowUniversalAccessFromFileURLs: true,
      allowContentAccess: true,
      domStorageEnabled: true,
      javaScriptEnabled: true,
      useWideViewPort: true,
      mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW);

  @override
  void initState() {
    if (widget.enablePullToRefresh) {
      _pullToRefreshController = PullToRefreshController(
          settings: PullToRefreshSettings(
              color: ThemeColors.white,
              backgroundColor: ThemeColors.primaryColor),
          onRefresh: () async {
            if (defaultTargetPlatform == TargetPlatform.android) {
              await _inAppWebViewController?.reload();
            } else if (defaultTargetPlatform == TargetPlatform.iOS) {
              await _inAppWebViewController?.loadUrl(
                  urlRequest:
                  URLRequest(url: await _inAppWebViewController?.getUrl()));
            }
            _pullToRefreshController?.endRefreshing();
          });
    }

    super.initState();
  }

  @override
  void dispose() {
    for (var handler in WebHandlerNames.all) {
      _inAppWebViewController?.removeJavaScriptHandler(handlerName: handler);
    }
    _inAppWebViewController?.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant WebViewContainer oldWidget) {
    if (oldWidget.url != widget.url) {
      loadWebView();
    }
    super.didUpdateWidget(oldWidget);
  }

  loadWebView() async {
    String webPageUrl = environment.webAppUrl;
    if (widget.url != null) {
      webPageUrl = "$webPageUrl${widget.url}";
    }
    _inAppWebViewController
        ?.loadUrl(
        urlRequest: URLRequest(
            url: WebUri("${environment.webAppUrl}${widget.url}")))
        .then((value) async {
      if (defaultTargetPlatform == TargetPlatform.android) {
        await _inAppWebViewController?.clearHistory();
      }
    });

  }

  handleCustomSchemaRoute(BuildContext context, String url) {
    switch (url.replaceFirst(_customSchema, '')) {
      case "dashboard":
        Navigator.pushNamedAndRemoveUntil(
            context, Routes.home, (route) => false);

        break;
      default:
        return;
    }
  }

  _onWebViewCreated(InAppWebViewController controller) async {
    final session = await AppSessionStorage().getString(SessionKeys.user);
    await controller.webStorage.localStorage.setItem(key: SessionKeys.user, value: session);
    _inAppWebViewController = controller;
    _inAppWebViewController?.addJavaScriptHandler(handlerName: WebHandlerNames.getDeviceDetail, callback: (dynamic data) => getDeviceDetails(data));
    _inAppWebViewController?.addJavaScriptHandler(handlerName: WebHandlerNames.logOut, callback: (dynamic data) => logout(context));
    _inAppWebViewController?.addJavaScriptHandler(handlerName: WebHandlerNames.appLoader, callback: (dynamic data) => appLoader(context, data));
    _inAppWebViewController?.addJavaScriptHandler(handlerName: WebHandlerNames.getCurrentUser, callback: (dynamic data) => getCurrentUser());
    _inAppWebViewController?.addJavaScriptHandler(handlerName: WebHandlerNames.updateUserDetail, callback: (dynamic data) => updateUserDetail(data));
    _inAppWebViewController?.addJavaScriptHandler(handlerName: WebHandlerNames.downloadFile, callback: (dynamic args) => _handleDownloadFile(args));
    _inAppWebViewController?.addJavaScriptHandler(handlerName: WebHandlerNames.getTenantId, callback: (dynamic args) => getTenantId());
    _inAppWebViewController?.addJavaScriptHandler(
        handlerName: WebHandlerNames.downloadExcel,
        callback: (dynamic args) {
          debugPrint('downloadExcel handler triggered');
          return _handleDownloadExcel(args);
        });
    WebViewControllerUtils.controller = controller;
    widget.onWebViewCreated?.call(controller);
  }

  onPopInvoked(didPop, _) async {
    if (didPop) {
      return;
    }
    final canWebGoBack = await _inAppWebViewController?.canGoBack();
    if (mounted) {
      if (canWebGoBack ?? false) {
        await _inAppWebViewController?.goBack();
      } else if (Navigator.canPop(context)) {
        Navigator.pop(context);
      } else {
        if (backPressTime != null &&
            DateTime.now().difference(backPressTime!) <
                const Duration(seconds: 2)) {
          SystemNavigator.pop(animated: true);
        } else {
          ToastMessage.show("Press again to exit.");
        }
        backPressTime = DateTime.now();
      }
    }
  }

  _checkWebSession(
      InAppWebViewController inAppWebViewController, WebUri? webUri) async {
    if (webUri?.path == '/auth/login') {
      //AppLoader().show();
      Future.delayed(const Duration(milliseconds: 500), () async {
        final userSession = await _inAppWebViewController
            ?.webStorage.localStorage
            .getItem(key: SessionKeys.user);
        if (userSession != null) {
          loadWebView();
        }
        // AppLoader().hide();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: onPopInvoked,
      child: InAppWebView(
        initialSettings: inAppWebViewSettings,
        pullToRefreshController: _pullToRefreshController,
        onWebViewCreated: _onWebViewCreated,
        onReceivedError: (webController, res, error) async {
          if (error.type == WebResourceErrorType.HOST_LOOKUP) {
            await webController.loadFile(
                assetFilePath: 'assets/files/connection_error.html');
          }
        },
        onReceivedHttpError: (webController, res, error) {
          debugPrint(error.reasonPhrase);
        },
        onLoadStart: (controller, uri) async {
          // AppLoader().show();
          // ✅ Sync session when loading new page
          if (uri != null) {
            try {
              final uriHost = uri.host.toLowerCase();
              final isAllowed = allowDomainToOpenInApp.any((domain) =>
                  uriHost.contains(domain.toLowerCase())
              );
              if (isAllowed) {
                final session = await AppSessionStorage().getString(SessionKeys.user);
                if (session != null && session.isNotEmpty) {
                  await controller.webStorage.localStorage
                      .setItem(key: SessionKeys.user, value: session);
                  debugPrint('✅ Session synced on load start');
                }
              }
            } catch (e) {
              debugPrint('Error syncing session on load start: $e');
            }
          }
        },
        onLoadStop: (controller, uri) async {
          final session = await AppSessionStorage().getString(SessionKeys.user);
          await controller.webStorage.localStorage
              .setItem(key: SessionKeys.user, value: session);
          AppLoader().hide();
        },
        onProgressChanged: (controller, progress) {},
        onUpdateVisitedHistory: (webViewController, uri, value) async {
          _checkWebSession(webViewController, uri);
        },
        onNavigationResponse: (webController, navigationAction) async {
          return NavigationResponseAction.ALLOW;
        },
        onTitleChanged: (controller, title) async {
          titleNotifier.value = title ?? '';
        },
        shouldOverrideUrlLoading: (webController, navigationAction) async {
          URLRequest urlRequest = navigationAction.request;
          final requestUrl = urlRequest.url.toString();
          // Handle custom schema
          if (requestUrl.contains(_customSchema)) {
            handleCustomSchemaRoute(context, requestUrl);
            return NavigationActionPolicy.CANCEL;
          }

          final allowInApp = allowDomainToOpenInApp.any((element) => urlRequest.url.toString().contains(element));

          if(allowInApp){
            final session = await AppSessionStorage().getString(SessionKeys.user);
            if (session != null && session.isNotEmpty) {
              await webController.webStorage.localStorage
                  .setItem(key: SessionKeys.user, value: session);
              debugPrint('✅ Session synced for navigation');
            }
            return NavigationActionPolicy.ALLOW;
          }
          if (!urlRequest.url.toString().contains(environment.webAppUrl)) {
            final requestUri = Uri.parse(urlRequest.url.toString());
            try {
              await launchUrl(requestUri);
            } catch (e) {}
            return NavigationActionPolicy.CANCEL;
          }
          return NavigationActionPolicy.ALLOW;
          },
        initialUrlRequest:
        URLRequest(url: WebUri("${environment.webAppUrl}${widget.url}")),

        onPermissionRequest: (webViewController, request) async {
          return PermissionResponse(
            action: PermissionResponseAction.GRANT,
            resources: request.resources,
          );
        },

        onGeolocationPermissionsShowPrompt: (controller, origin) async {
          return GeolocationPermissionShowPromptResponse(
            origin: origin,
            allow: true,
            retain: true,
          );
        },

        // ✅ Handle document downloads - especially blob URLs and Excel files
        onDownloadStartRequest: (controller, downloadStartRequest) async {
          await _handleDownloadRequest(controller, downloadStartRequest);
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _handleDownloadFile(List<dynamic> args) async {
    try {
      if (args.length < 2) {
        return {'success': false, 'message': 'Invalid arguments'};
      }

      String base64Data = args[0].toString();
      String fileName = args[1].toString();

      // Remove data URL prefix if present (data:mime/type;base64,)
      if (base64Data.contains(',')) {
        base64Data = base64Data.split(',').last;
      }

      // Decode base64 data
      Uint8List bytes = base64Decode(base64Data);

      // Get app documents directory
      final dir = await getApplicationDocumentsDirectory();
      final downloadsDir = Directory('${dir.path}/Downloads');

      // Create Downloads directory if it doesn't exist
      if (!await downloadsDir.exists()) {
        await downloadsDir.create(recursive: true);
      }

      // Create file path
      final filePath = '${downloadsDir.path}/$fileName';
      final file = File(filePath);

      // Write file
      await file.writeAsBytes(bytes);
      print('testa');

      // Show success message
      if (mounted) {
        ToastMessage.show('File downloaded: $fileName');
      }

      // Try to open the file
      try {
        final result = await OpenFile.open(filePath);
        debugPrint('Open file result: ${result.message}');
      } catch (e) {
        debugPrint('Could not open file: $e');
        // File saved but couldn't open - still a success
      }

      debugPrint('File saved at: $filePath');

      return {
        'success': true,
        'message': 'File downloaded successfully',
        'filePath': filePath
      };

    } catch (error) {
      debugPrint('Download error: $error');
      if (mounted) {
        ToastMessage.show('Download failed: ${error.toString()}');
      }
      return {
        'success': false,
        'message': 'Download failed: ${error.toString()}'
      };
    }
  }
  Future<Map<String, dynamic>> _handleDownloadExcelLocal(List<dynamic> args) async {
    try {
      debugPrint('downloadExcel called - downloading sample Excel file');

      // Load the sample Excel file from assets
      final ByteData data = await rootBundle.load('assets/sample_excel.xlsx');
      final List<int> bytes = data.buffer.asUint8List();

      // Generate filename with timestamp to avoid conflicts
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = 'sample_excel_$timestamp.xlsx';

      // Get app documents directory
      final dir = await getApplicationDocumentsDirectory();
      final downloadsDir = Directory('${dir.path}/Downloads');

      // Create Downloads directory if it doesn't exist
      if (!await downloadsDir.exists()) {
        await downloadsDir.create(recursive: true);
        debugPrint('Created downloads directory: ${downloadsDir.path}');
      }

      // Create file path
      final filePath = '${downloadsDir.path}/$fileName';
      final file = File(filePath);

      // Write file
      await file.writeAsBytes(bytes);
      debugPrint('Sample Excel file saved to: $filePath');

      // Show success message with path
      if (mounted) {
        ToastMessage.show('Excel downloaded to:\n${downloadsDir.path}/$fileName');
      }

      // File downloaded successfully - no auto-open to avoid asking user

      return {
        'success': true,
        'message': 'Sample Excel file downloaded successfully',
        'filePath': filePath,
        'fileName': fileName
      };

    } catch (error, stackTrace) {
      debugPrint('Excel download error: $error');
      debugPrint('Stack trace: $stackTrace');

      if (mounted) {
        ToastMessage.show('Excel download failed');
      }

      return {
        'success': false,
        'message': 'Excel download failed: ${error.toString()}'
      };
    }
  }

  Future<Map<String, dynamic>> _handleDownloadExcel(List<dynamic> args) async {
    try {
      debugPrint('downloadExcel called with args: $args');
      debugPrint('Args length: ${args.length}');

      if (args.isEmpty) {
        debugPrint('No arguments provided to downloadExcel');
        return {'success': false, 'message': 'No arguments provided'};
      }

      String? base64Data;
      String fileName = 'excel_export_${DateTime.now().millisecondsSinceEpoch}.xlsx';

      // Simple argument handling - expect base64Data as first argument, fileName as optional second
      if (args.length >= 1) {
        var firstArg = args[0];
        debugPrint('First argument type: ${firstArg.runtimeType}');
        debugPrint('First argument: $firstArg');

        if (firstArg is String) {
          base64Data = firstArg;
        } else if (firstArg is Map) {
          base64Data = firstArg['data']?.toString() ??
              firstArg['base64']?.toString() ??
              firstArg['content']?.toString();
          fileName = firstArg['fileName']?.toString() ??
              firstArg['filename']?.toString() ??
              firstArg['name']?.toString() ??
              fileName;
        }
      }

      if (args.length >= 2) {
        var secondArg = args[1];
        if (secondArg is String && secondArg.isNotEmpty) {
          fileName = secondArg;
        }
      }

      // Ensure .xlsx extension
      if (!fileName.toLowerCase().endsWith('.xlsx') &&
          !fileName.toLowerCase().endsWith('.xls')) {
        fileName += '.xlsx';
      }

      debugPrint('Processing base64Data: ${base64Data?.substring(0, 50)}...');
      debugPrint('File name: $fileName');

      if (base64Data == null || base64Data.isEmpty) {
        debugPrint('No valid base64 data found');
        return {'success': false, 'message': 'No valid Excel data provided'};
      }

      // Remove data URL prefix if present
      if (base64Data.contains(',')) {
        debugPrint('Removing data URL prefix');
        base64Data = base64Data.split(',').last;
      }

      // Decode base64 data
      Uint8List bytes;
      try {
        bytes = base64Decode(base64Data);
        debugPrint('Successfully decoded ${bytes.length} bytes');
      } catch (e) {
        debugPrint('Base64 decode error: $e');
        return {'success': false, 'message': 'Invalid base64 data: ${e.toString()}'};
      }

      // Get app documents directory
      final dir = await getApplicationDocumentsDirectory();
      final downloadsDir = Directory('${dir.path}/Downloads');

      // Create Downloads directory if it doesn't exist
      if (!await downloadsDir.exists()) {
        await downloadsDir.create(recursive: true);
        debugPrint('Created downloads directory: ${downloadsDir.path}');
      }

      // Create file path
      final filePath = '${downloadsDir.path}/$fileName';
      final file = File(filePath);

      // Write file
      await file.writeAsBytes(bytes);
      debugPrint('File written to: $filePath');

      // Show success message
      if (mounted) {
        ToastMessage.show('Excel downloaded: $fileName');
      }

      // Try to open the Excel file
      try {
        final result = await OpenFile.open(filePath);
        debugPrint('Open Excel result: ${result.message}');
      } catch (e) {
        debugPrint('Could not auto-open Excel: $e');
        // Still a success even if we can't open it
      }

      return {
        'success': true,
        'message': 'Excel file downloaded successfully',
        'filePath': filePath,
        'fileName': fileName
      };

    } catch (error, stackTrace) {
      debugPrint('Excel download error: $error');
      debugPrint('Stack trace: $stackTrace');

      if (mounted) {
        ToastMessage.show('Excel download failed');
      }

      return {
        'success': false,
        'message': 'Excel download failed: ${error.toString()}'
      };
    }
  }

  Future<void> _handleDownloadRequest(InAppWebViewController controller, DownloadStartRequest downloadStartRequest) async {
    final url = downloadStartRequest.url.toString();
    final suggestedFilename = downloadStartRequest.suggestedFilename ?? 'download';
    final mimeType = downloadStartRequest.mimeType ?? '';
    final contentLength = downloadStartRequest.contentLength;

    debugPrint("Download requested: $url");
    debugPrint("Suggested filename: $suggestedFilename");
    debugPrint("MIME type: $mimeType");
    debugPrint("Content length: $contentLength");

    try {
      // Handle blob URLs by injecting JavaScript to convert to base64
      if (url.startsWith('blob:')) {
        debugPrint("Handling blob URL download");

        // Add a JavaScript handler to receive the blob data
        controller.addJavaScriptHandler(
          handlerName: 'blobDownloadCallback',
          callback: (args) async {
            if (args.isNotEmpty) {
              String base64Data = args[0].toString();
              debugPrint("Received blob data via callback: ${base64Data.substring(0, 50)}...");

              if (base64Data.startsWith('data:')) {
                if (base64Data.contains(',')) {
                  base64Data = base64Data.split(',').last;
                }
                await _saveFileFromBase64(base64Data, suggestedFilename, mimeType);
              }
            }
          },
        );

        // Inject JavaScript to convert blob to base64 and send via callback
        final script = '''
          (function() {
            try {
              fetch('$url')
                .then(response => response.blob())
                .then(blob => {
                  const reader = new FileReader();
                  reader.onload = function() {
                    window.flutter_inappwebview.callHandler('blobDownloadCallback', reader.result);
                  };
                  reader.onerror = function() {
                    window.flutter_inappwebview.callHandler('blobDownloadCallback', 'ERROR: Failed to read blob');
                  };
                  reader.readAsDataURL(blob);
                })
                .catch(error => {
                  window.flutter_inappwebview.callHandler('blobDownloadCallback', 'ERROR: ' + error.message);
                });
              return 'PROCESSING';
            } catch(e) {
              window.flutter_inappwebview.callHandler('blobDownloadCallback', 'ERROR: ' + e.message);
              return 'ERROR: ' + e.message;
            }
          })();
        ''';

        debugPrint("Executing JavaScript for blob conversion with callback");
        final result = await controller.evaluateJavascript(source: script);
        debugPrint("JavaScript immediate result: $result");

        // Wait a bit for the callback to process
        await Future.delayed(const Duration(milliseconds: 1000));

        // Remove the temporary handler
        controller.removeJavaScriptHandler(handlerName: 'blobDownloadCallback');
        return;
      }

      // Handle regular HTTP URLs
      if (url.startsWith('http')) {
        debugPrint("Handling HTTP URL download");
        await _downloadFromUrl(url, suggestedFilename, mimeType);
        return;
      }

      // Fallback - try to open in external app
      debugPrint("Using fallback external launch");
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      }

    } catch (e) {
      debugPrint("Download failed: $e");
      if (mounted) {
        ToastMessage.show('Download failed');
      }
    }
  }

  Future<void> _saveFileFromBase64(String base64Data, String filename, String mimeType) async {
    try {
      // Decode base64
      final bytes = base64Decode(base64Data);

      // Ensure proper file extension based on MIME type
      String finalFilename = filename;
      if (mimeType.contains('excel') || mimeType.contains('spreadsheet')) {
        if (!filename.toLowerCase().endsWith('.xlsx') && !filename.toLowerCase().endsWith('.xls')) {
          finalFilename += '.xlsx';
        }
      }

      // Get downloads directory
      final dir = await getApplicationDocumentsDirectory();
      final downloadsDir = Directory('${dir.path}/Downloads');

      if (!await downloadsDir.exists()) {
        await downloadsDir.create(recursive: true);
      }

      // Save file
      final filePath = '${downloadsDir.path}/$finalFilename';
      final file = File(filePath);
      await file.writeAsBytes(bytes);

      debugPrint('File saved to: $filePath');

      // Show success message
      if (mounted) {
        ToastMessage.show('Downloaded: $finalFilename');
      }

      // Try to open file
      try {
        await OpenFile.open(filePath);
      } catch (e) {
        debugPrint('Could not auto-open file: $e');
      }

    } catch (e) {
      debugPrint('Save from base64 failed: $e');
      if (mounted) {
        ToastMessage.show('Save failed');
      }
    }
  }

  Future<void> _downloadFromUrl(String url, String filename, String mimeType) async {
    try {
      debugPrint('Downloading from URL: $url');

      // Get user session for authentication if needed
      final session = await AppSessionStorage().getString(SessionKeys.user);
      final headers = <String, String>{};

      if (session != null) {
        // Add any auth headers if needed
        headers['Authorization'] = 'Bearer $session';
      }

      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;

        // Ensure proper file extension
        String finalFilename = filename;
        if (mimeType.contains('excel') || mimeType.contains('spreadsheet')) {
          if (!filename.toLowerCase().endsWith('.xlsx') && !filename.toLowerCase().endsWith('.xls')) {
            finalFilename += '.xlsx';
          }
        }

        // Get downloads directory
        final dir = await getApplicationDocumentsDirectory();
        final downloadsDir = Directory('${dir.path}/Downloads');

        if (!await downloadsDir.exists()) {
          await downloadsDir.create(recursive: true);
        }

        // Save file
        final filePath = '${downloadsDir.path}/$finalFilename';
        final file = File(filePath);
        await file.writeAsBytes(bytes);

        debugPrint('Downloaded file to: $filePath');

        // Show success message
        if (mounted) {
          ToastMessage.show('Downloaded: $finalFilename');
        }

        // Try to open file
        try {
          await OpenFile.open(filePath);
        } catch (e) {
          debugPrint('Could not auto-open file: $e');
        }

      } else {
        debugPrint('Download failed with status: ${response.statusCode}');
        if (mounted) {
          ToastMessage.show('Download failed');
        }
      }

    } catch (e) {
      debugPrint('URL download failed: $e');
      if (mounted) {
        ToastMessage.show('Download failed');
      }
    }
  }

  String getTenantId() {
    return CommonConstants.tenantId;
  }
}
