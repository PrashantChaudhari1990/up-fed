import 'package:base_mobile_app/ui/shared_widget/web_view_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
class WebViewScreen extends StatelessWidget {
  final String? routeName;
  InAppWebViewController? _inAppWebViewController;

  WebViewScreen({super.key, this.routeName});

  @override
  Widget build(BuildContext context) {
    String route = routeName ?? ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(),
      body: WebViewContainer(url: route,
      onWebViewCreated: (controller){
        _inAppWebViewController = controller;
      },),
    );
  }
}
