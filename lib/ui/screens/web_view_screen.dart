import 'package:base_mobile_app/ui/shared_widget/kh_app_bar.dart';
import 'package:base_mobile_app/ui/shared_widget/web_view_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
class WebViewScreen extends StatefulWidget {
  final String? routeName;
  final String? title;
  final bool? showNotification;
  final bool? showCart;
  final bool showAppBar;

  const WebViewScreen({super.key, this.routeName,this.title,this.showNotification,this.showCart,this.showAppBar=true});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  InAppWebViewController? _inAppWebViewController;

  @override
  Widget build(BuildContext context) {
    String route = widget.routeName ?? ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      appBar: widget.showAppBar ? KhAppBar(title: widget.title,notificationAction: widget.showNotification,cartAction: widget.showCart,):null,
      body: SafeArea(
        child: WebViewContainer(url: route,
        onWebViewCreated: (controller)async{
          _inAppWebViewController = controller;
        },),
      ),
    );
  }
}
