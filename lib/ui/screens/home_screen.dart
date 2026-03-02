import 'package:permission_handler/permission_handler.dart';
import 'package:mhassoc_ui/constant/web_app_routes.dart';
import 'package:mhassoc_ui/themes/styles/theme_colors.dart';
import 'package:mhassoc_ui/ui/shared_widget/kh_app_bar.dart';
import 'package:mhassoc_ui/ui/shared_widget/web_view_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../constant/common_constants.dart';
import '../../constant/session_keys.dart';
import '../../utils/app_session_storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTenentId();
  }
  Future<void> requestLocationPermission() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      status = await Permission.location.request();
    }
  }
  Future<void> getTenentId() async {
    await requestLocationPermission();
    try
    {
      CommonConstants.tenantId =
      (await AppSessionStorage().getString(SessionKeys.tenantId))!;
    }catch(exc){
      // Failed to get tenant ID - continue with defaults
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KhAppBar(
        systemNavigationBarColor: ThemeColors.white,
        statusBarColor: ThemeColors.white,
        statusBrightness: Brightness.dark,
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: WebViewContainer(
                url:'',
                enablePullToRefresh: false,
                onWebViewCreated: (controller) async {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
