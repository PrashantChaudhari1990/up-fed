import 'package:mhassoc_ui/ui/shared_widget/kh_app_bar.dart';
import 'package:mhassoc_ui/ui/shared_widget/web_view_container.dart';
import 'package:flutter/material.dart';

class WebViewScreen extends StatefulWidget {
  final String? routeName;
  final String? title;
  final bool showAppBar;

  const WebViewScreen(
      {super.key, this.routeName, this.title, this.showAppBar = true});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {

  @override
  Widget build(BuildContext context) {
    String route = widget.routeName ??
        ModalRoute.of(context)?.settings.arguments as String;
    return Scaffold(
      appBar: widget.showAppBar
          ? KhAppBar(
              title: widget.title,
            )
          : null,
      body: SafeArea(
        child: WebViewContainer(
          url: route,
          onWebViewCreated: (controller) async {
            // WebView controller created
          },
        ),
      ),
    );
  }
}
