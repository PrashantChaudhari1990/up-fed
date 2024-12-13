import 'dart:async';
import 'package:base_mobile_app/constant/session_keys.dart';
import 'package:base_mobile_app/themes/styles/theme_colors.dart';
import 'package:base_mobile_app/utils/app_session_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/server_config.dart';

class WebViewContainer extends StatefulWidget {
  final String? url;
  final void Function(InAppWebViewController)? onWebViewCreated;
  final bool enablePullToRefresh;

  const WebViewContainer({super.key, this.url,this.onWebViewCreated,this.enablePullToRefresh=false});

  @override
  State<WebViewContainer> createState() => _WebViewContainerState();
}

class _WebViewContainerState extends State<WebViewContainer> {

  InAppWebViewController? _inAppWebViewController;

  PullToRefreshController? _pullToRefreshController;

  final InAppWebViewSettings _inAppWebViewSettings = InAppWebViewSettings(
    isTextInteractionEnabled: false,
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

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop,_) async {
          if (didPop) {
            return;
          }
          final canWebGoBack = await _inAppWebViewController?.canGoBack();
          if(canWebGoBack??false){
            _inAppWebViewController?.goBack();
          }else if(Navigator.canPop(context)){
            Navigator.pop(context);
          }
        },
    child: InAppWebView(
      initialSettings: _inAppWebViewSettings,
      pullToRefreshController: widget.enablePullToRefresh ? _pullToRefreshController : null,
      onWebViewCreated: (controller) async {
        widget.onWebViewCreated?.call(controller);
        _inAppWebViewController  = controller;
        final session = await AppSessionStorage().getString(SessionKeys.user);
        await _inAppWebViewController?.webStorage.localStorage.setItem(key: SessionKeys.user, value: session);
      },
      onReceivedError: (webController,res,error){
        debugPrint(error.description);
      },
      onLoadStart: (c,u) async {

      },
      onProgressChanged: (controller,progress){
        // double.parse((progress*0.01).toStringAsFixed(1));

      },
      onUpdateVisitedHistory: (webViewController,uri,value){
        debugPrint(uri?.rawValue);
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