import 'package:kh_dealer_app/constant/web_app_routes.dart';
import 'package:kh_dealer_app/routes.dart';
import 'package:kh_dealer_app/themes/styles/theme_colors.dart';
import 'package:kh_dealer_app/utils/app_loader.dart';
import 'package:kh_dealer_app/utils/webview_controller_utils.dart';
import 'package:kh_dealer_app/web_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/server_config.dart';
import '../../constant/session_keys.dart';
import '../../utils/app_session_storage.dart';

class WebViewContainer extends StatefulWidget {
  final String? url;
  final void Function(InAppWebViewController)? onWebViewCreated;
  final bool enablePullToRefresh;

  const WebViewContainer({super.key, this.url,this.onWebViewCreated,this.enablePullToRefresh=false});

  @override
  State<WebViewContainer> createState() => _WebViewContainerState();
}

class _WebViewContainerState extends State<WebViewContainer> {

  PullToRefreshController? _pullToRefreshController;
  InAppWebViewController? _inAppWebViewController;

  final InAppWebViewSettings _inAppWebViewSettings = InAppWebViewSettings(
    isTextInteractionEnabled: false,
    useShouldOverrideUrlLoading: true,
    clearCache: true,
    scrollsToTop: true,
    allowsInlineMediaPlayback: true
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
            await _inAppWebViewController?.reload();
            _pullToRefreshController?.endRefreshing();
          }
      );
    }
    super.initState();
  }

  @override
  void didUpdateWidget(covariant WebViewContainer oldWidget) {
    if(oldWidget.url != widget.url){
      _loadWebView();
    }
    super.didUpdateWidget(oldWidget);
  }

  _loadWebView() async {
    String webPageUrl = environment.webAppUrl;
    if(widget.url != null){
      webPageUrl =  "$webPageUrl${widget.url}";
    }
    _inAppWebViewController?.loadUrl(urlRequest: URLRequest(url: WebUri("${environment.webAppUrl}${widget.url}")));
  }

  _onWebViewCreated(InAppWebViewController controller) async {
    _inAppWebViewController = controller;
    final session = await AppSessionStorage().getString(SessionKeys.user);
    await _inAppWebViewController?.webStorage.localStorage.setItem(key: SessionKeys.user, value: session);
    widget.onWebViewCreated?.call(controller);
    controller.addJavaScriptHandler(handlerName: 'getDeviceDetail', callback: (dynamic data) => getDeviceDetails(data));
    controller.addJavaScriptHandler(handlerName: 'logOut', callback: (dynamic data) => logout(context));
    controller.addJavaScriptHandler(handlerName: 'handleRegisterSuccess', callback: (dynamic data) => handleRegisterSuccess(context,data));
    controller.addJavaScriptHandler(handlerName: 'appLoader', callback: (dynamic data) => appLoader(context,data));
    controller.addJavaScriptHandler(handlerName: 'onApprovalStatus', callback: (dynamic data) => onApprovalStatus(context,data));
    WebViewControllerUtils.controller = controller;
  }

  _onPopInvoked(didPop, _) async {
    if (didPop) {
      return;
    }
    final canWebGoBack = await _inAppWebViewController?.canGoBack();
    if (mounted) {
      if (canWebGoBack ?? false) {
        _inAppWebViewController?.goBack();
      } else if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: _onPopInvoked,
    child: InAppWebView(
      initialSettings: _inAppWebViewSettings,
      pullToRefreshController: _pullToRefreshController,
      onWebViewCreated: _onWebViewCreated,
      onReceivedError: (webController,res,error){
        debugPrint(error.description);
      },
      onLoadStart: (controller,uri) async {
        AppLoader().show();
      },
      onLoadStop: (controller,uri){
        AppLoader().hide();
      },
      onProgressChanged: (controller,progress){},
      onUpdateVisitedHistory: (webViewController,uri,value) async {
        String? currentRouteName = ModalRoute.of(context)?.settings.name;
        if(uri?.path == WebAppRoutes.categoryScreen && currentRouteName != Routes.category){
          Navigator.of(context).pushNamed(Routes.category);
          if(await webViewController.canGoBack()){
            webViewController.goBack();
          }
        }
        debugPrint(uri?.rawValue);
      },
      onConsoleMessage: (c,m){
        print(m);
      },
      onNavigationResponse: (webController,navigationAction) async {
         return NavigationResponseAction.ALLOW;
      },
      onReceivedHttpError: (controller,resourceRequest,resourceResponse){
        print(resourceRequest);
        print(resourceResponse);
      },
      shouldOverrideUrlLoading: (webController,navigationAction)async{
        if(!navigationAction.request.url.toString().contains(environment.webAppUrl)) {
          final requestUri = Uri.parse(navigationAction.request.url.toString());
          if(await canLaunchUrl(requestUri)){
            await launchUrl(requestUri);
          }
          return NavigationActionPolicy.CANCEL;
        }
        return NavigationActionPolicy.ALLOW;
      },
      initialUrlRequest: URLRequest(url: WebUri("${environment.webAppUrl}${widget.url}")),
      onPermissionRequest: (webViewController,request)async{
        return PermissionResponse(action: PermissionResponseAction.GRANT,resources: request.resources);
      },
    )
    );
  }
}