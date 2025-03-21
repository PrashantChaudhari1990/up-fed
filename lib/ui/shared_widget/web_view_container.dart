import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:kh_dealer_app/constant/web_app_routes.dart';
import 'package:kh_dealer_app/models/app_bar_config.dart';
import 'package:kh_dealer_app/routes.dart';
import 'package:kh_dealer_app/themes/styles/theme_colors.dart';
import 'package:kh_dealer_app/utils/app_loader.dart';
import 'package:kh_dealer_app/utils/toast_message.dart';
import 'package:kh_dealer_app/utils/webview_controller_utils.dart';
import 'package:kh_dealer_app/web_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/server_config.dart';
import '../../constant/session_keys.dart';
import '../../utils/app_session_storage.dart';
import '../../utils/global_notifier.dart';

class WebViewContainer extends StatefulWidget {
  final String? url;
  final void Function(InAppWebViewController)? onWebViewCreated;
  final bool enablePullToRefresh;

  const WebViewContainer({super.key, this.url,this.onWebViewCreated,this.enablePullToRefresh=false});

  @override
  State<WebViewContainer> createState() => WebViewContainerState();
}

class WebViewContainerState extends State<WebViewContainer> {

  final String _customSchema = 'kh-dealer-app:';

  PullToRefreshController? _pullToRefreshController;
  InAppWebViewController? _inAppWebViewController;

  DateTime? backPressTime;

  InAppWebViewSettings inAppWebViewSettings = InAppWebViewSettings(
    useShouldOverrideUrlLoading: true,
    clearCache: true,
    cacheEnabled: false,
    clearSessionCache: true,
    allowsInlineMediaPlayback: true,
      isInspectable: kDebugMode,
      mediaPlaybackRequiresUserGesture: false,
      iframeAllow: "camera; microphone",
      iframeAllowFullscreen: false
  );

  @override
  void initState() {
    if(widget.enablePullToRefresh){
      _pullToRefreshController = PullToRefreshController(
          settings: PullToRefreshSettings(
              color: ThemeColors.white,
              backgroundColor: ThemeColors.primaryColor
          ),
          onRefresh: () async {
            if (defaultTargetPlatform == TargetPlatform.android) {
              await _inAppWebViewController?.reload();
            } else if (defaultTargetPlatform == TargetPlatform.iOS) {
              await _inAppWebViewController?.loadUrl(
                  urlRequest:
                  URLRequest(url: await _inAppWebViewController?.getUrl()));
            }
            _pullToRefreshController?.endRefreshing();
          }
      );
    }
    super.initState();
  }

  @override
  void dispose() {
    _inAppWebViewController?.removeJavaScriptHandler(handlerName: 'getDeviceDetail');
    _inAppWebViewController?.removeJavaScriptHandler(handlerName: 'logOut');
    _inAppWebViewController?.removeJavaScriptHandler(handlerName: 'handleRegisterSuccess');
    _inAppWebViewController?.removeJavaScriptHandler(handlerName: 'appLoader');
    _inAppWebViewController?.removeJavaScriptHandler(handlerName: 'onApprovalStatus');
    _inAppWebViewController?.removeJavaScriptHandler(handlerName: 'updateUserDetail');
    _inAppWebViewController?.removeJavaScriptHandler(handlerName: 'toggleAppBar');
    _inAppWebViewController?.removeJavaScriptHandler(handlerName: 'toggleBottomNavigation');
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant WebViewContainer oldWidget) {
    if(oldWidget.url != widget.url){
      loadWebView();
    }
    super.didUpdateWidget(oldWidget);
  }

  loadWebView() async {
    String webPageUrl = environment.webAppUrl;
    if(widget.url != null){
      webPageUrl =  "$webPageUrl${widget.url}";
    }
    _inAppWebViewController?.loadUrl(urlRequest: URLRequest(url: WebUri("${environment.webAppUrl}${widget.url}"))).then((value) async {
      if(defaultTargetPlatform == TargetPlatform.android){
        await _inAppWebViewController?.clearHistory();
      }
    });
  }

  handleCustomSchemaRoute(BuildContext context, String url) {
    switch (url.replaceFirst(_customSchema, '')) {
      case "dashboard":
        Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false);
        break;
      default:
        return;
    }
  }

  _onWebViewCreated(InAppWebViewController controller) async {
    final session = await AppSessionStorage().getString(SessionKeys.user);
    await controller.webStorage.localStorage.setItem(key: SessionKeys.user, value: session);
    _inAppWebViewController = controller;
    _inAppWebViewController?.addJavaScriptHandler(handlerName: 'getDeviceDetail', callback: (dynamic data) => getDeviceDetails(data));
    _inAppWebViewController?.addJavaScriptHandler(handlerName: 'logOut', callback: (dynamic data) => logout(context));
    _inAppWebViewController?.addJavaScriptHandler(handlerName: 'handleRegisterSuccess', callback: (dynamic data) => handleRegisterSuccess(context,data));
    _inAppWebViewController?.addJavaScriptHandler(handlerName: 'appLoader', callback: (dynamic data) => appLoader(context,data));
    _inAppWebViewController?.addJavaScriptHandler(handlerName: 'onApprovalStatus', callback: (dynamic data) => onApprovalStatus(context,data));
    _inAppWebViewController?.addJavaScriptHandler(handlerName: 'getCurrentUser', callback: (dynamic data) => getCurrentUser());
    _inAppWebViewController?.addJavaScriptHandler(handlerName: 'updateUserDetail', callback: (dynamic data) => updateUserDetail(data));
    _inAppWebViewController?.addJavaScriptHandler(handlerName: 'toggleAppBar', callback: (dynamic data) => toggleAppBar(data));
    _inAppWebViewController?.addJavaScriptHandler(handlerName: 'toggleBottomNavigation', callback: (dynamic data) => toggleBottomNavigation(data));
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
      }else{
        if(backPressTime != null && DateTime.now().difference(backPressTime!)<const Duration(seconds: 2)){
          SystemNavigator.pop(animated: true);
        }else{
          ToastMessage.show("Press again to exit.");
        }
        backPressTime = DateTime.now();
      }
    }
  }

  _checkWebSession(InAppWebViewController inAppWebViewController, WebUri? webUri)async{
    if(webUri?.path == '/auth/login'){
      AppLoader().show();
      Future.delayed(const Duration(milliseconds: 500),()async{
        final userSession = await _inAppWebViewController?.webStorage.localStorage.getItem(key: SessionKeys.user);
        if(userSession != null){
          loadWebView();
        }
        AppLoader().show();
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
        onReceivedError: (webController,res,error){
          debugPrint(error.description);
        },
        onLoadStart: (controller,uri) async {
          AppLoader().show();
        },
        onLoadStop: (controller,uri) async {
          final session = await AppSessionStorage().getString(SessionKeys.user);
          await controller.webStorage.localStorage.setItem(key: SessionKeys.user, value: session);
          AppLoader().hide();
        },
        onProgressChanged: (controller,progress){},
        onUpdateVisitedHistory: (webViewController,uri,value) async {
          _checkWebSession(webViewController,uri);
          updateBottomNavigationBar(uri);
          updateAppBar(uri);
          debugPrint(uri?.rawValue);
        },
        onNavigationResponse: (webController,navigationAction) async {
          return NavigationResponseAction.ALLOW;
        },
        onTitleChanged:(controller,title) async {
          titleNotifier.value = title??'';
        },
        shouldOverrideUrlLoading: (webController, navigationAction) async {
          URLRequest urlRequest = navigationAction.request;
          if (urlRequest.url.toString().contains(_customSchema)) {
            handleCustomSchemaRoute(context, urlRequest.url.toString());
            return NavigationActionPolicy.CANCEL;
          }
          if(urlRequest.url.toString().contains("https://api.razorpay.com/")){
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
        initialUrlRequest: URLRequest(url: WebUri("${environment.webAppUrl}${widget.url}")),
        onPermissionRequest: (webViewController,request)async{
          return PermissionResponse(action: PermissionResponseAction.GRANT,resources: request.resources);
        },
      ),
    );
  }
  updateBottomNavigationBar(Uri? uri){
    if([WebAppRoutes.dashboard,WebAppRoutes.trips,WebAppRoutes.profile,WebAppRoutes.payments].contains(uri?.path)){
      homeBottomBarVisible.value = true;
    }else{
      homeBottomBarVisible.value = false;
    }
  }
  updateAppBar(Uri? uri)async{
    AppBarConfig? appBarConfig;
    if(uri?.queryParameters != null){
      try{
        appBarConfig = AppBarConfig.fromJson(uri?.queryParameters??{});
      }catch(e){}
    }
    appBarVisibleNotifier.value = appBarConfig?.appBarVisible??true;
    titleAppBarNotifier.value = !_isTitleBar(uri);
    userNameVisibleNotifier.value = _isUserNameVisible(uri);
    notificationVisibleNotifier.value = _isNotificationVisible(appBarConfig,uri);
    cartVisibleNotifier.value = _isCartVisible(appBarConfig,uri);
    titleVisibleNotifier.value = appBarConfig?.titleVisible??true;
  }
  _isTitleBar(Uri? uri){
    return [WebAppRoutes.dashboard,WebAppRoutes.trips,WebAppRoutes.payments,WebAppRoutes.dashboard].contains(uri?.path.toString());
  }
  _isUserNameVisible(Uri? uri){
    return [WebAppRoutes.dashboard,WebAppRoutes.trips,WebAppRoutes.payments].contains(uri?.path.toString());
  }
  _isCartVisible(AppBarConfig? appBarConfig,Uri? uri){
    return (appBarConfig?.cartVisible??false) || [WebAppRoutes.dashboard,WebAppRoutes.trips,WebAppRoutes.profile,WebAppRoutes.payments].contains(uri?.path.toString());
  }
  _isNotificationVisible(AppBarConfig? appBarConfig,Uri? uri){
    return (appBarConfig?.notificationVisible??false) || [WebAppRoutes.dashboard,WebAppRoutes.trips,WebAppRoutes.profile,WebAppRoutes.payments].contains(uri?.path.toString());
  }
  }