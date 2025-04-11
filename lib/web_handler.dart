import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:vendor_partner/models/user.dart';
import 'package:vendor_partner/routes.dart';
import 'package:vendor_partner/utils/app_loader.dart';
import 'package:vendor_partner/utils/app_session.dart';
import 'package:vendor_partner/utils/app_session_storage.dart';
import 'package:vendor_partner/utils/global_notifier.dart';
import 'package:vendor_partner/utils/toast_message.dart';
import 'package:vendor_partner/utils/webview_controller_utils.dart';
import 'constant/session_keys.dart';
import 'utils/device_info.dart';

bool _isUnderApprovalScreen = false;

Future<dynamic> getDeviceDetails(dynamic data) async {
  final deviceDetail = jsonEncode(await DeviceInfo.getDetail());
  return deviceDetail;
}

logout(BuildContext context) {
  AppSession().loginUser = null;
  WebViewControllerUtils.controller?.webStorage.localStorage.clear();
  Navigator.pushNamedAndRemoveUntil(context, Routes.login, (route) => false);
}

handleRegisterSuccess(BuildContext context, List<dynamic> data) async {
  if (data.isNotEmpty) {
    User user = User.fromJson(data[0]);
    await AppSessionStorage().setString(SessionKeys.user, jsonEncode(user));
    await WebViewControllerUtils.controller?.webStorage.localStorage.setItem(key: SessionKeys.user, value: data[0]);
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route) => false);
    }
  }
}

appLoader(BuildContext context, List<dynamic> data) async {
  if (data.isNotEmpty) {
    final loading = data[0];
    if (context.mounted) {
      if (loading == true) {
        AppLoader().show();
      } else {
        AppLoader().hide();
      }
    }
  }
}

onApprovalStatus(BuildContext context, List<dynamic> data) async {
  if (data.isNotEmpty) {
    String? currentRouteName = ModalRoute.of(context)?.settings.name;
    if(context.mounted && data[0]==true){
      _isUnderApprovalScreen = false;
      Navigator.pushNamedAndRemoveUntil(context, Routes.home, (route)=>false);
    }else if(currentRouteName != Routes.pendingVerification && !_isUnderApprovalScreen){
      _isUnderApprovalScreen = true;
      ToastMessage.show(data[1]??'');
      Navigator.pushNamedAndRemoveUntil(context, Routes.pendingVerification, (route)=>false);
    }
  }
}

getCurrentUser()async{
  final currentUser = await AppSession().loginUser;
  return currentUser;
}
updateUserDetail(data)async{
  if (data.isNotEmpty) {
    final userData = data[0];
    if(userData != null){
      AppSession().loginUser = jsonEncode(userData);
    }
  }
}
toggleAppBar(data)async{
  if (data.isNotEmpty) {
    final appBarVisible = data[0];
    if(appBarVisible != null){
      appBarVisibleNotifier.value = appBarVisible;
    }
  }
}
toggleBottomNavigation(data)async{
  if (data.isNotEmpty) {
    final bottomNavigation = data[0];
    if(bottomNavigation != null){
      homeBottomBarVisible.value = bottomNavigation;
    }
  }
}