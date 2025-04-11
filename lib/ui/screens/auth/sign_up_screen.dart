import 'package:vendor_partner/constant/web_app_routes.dart';
import 'package:vendor_partner/ui/shared_widget/web_view_container.dart';
import 'package:flutter/material.dart';
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    final phoneNumber = (ModalRoute.of(context)?.settings.arguments);
    return Scaffold(
      appBar: AppBar(
      ),
      body: WebViewContainer(
        url: '${WebAppRoutes.signUp}?phoneNumber=$phoneNumber',
      ),
    );
  }
}
