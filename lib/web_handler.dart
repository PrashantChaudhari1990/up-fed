import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:abcof_ui/routes.dart';
import 'package:abcof_ui/utils/app_loader.dart';
import 'package:abcof_ui/utils/app_session.dart';
import 'package:abcof_ui/utils/toast_message.dart';
import 'package:abcof_ui/utils/webview_controller_utils.dart';
import 'utils/device_info.dart';

Future<dynamic> getDeviceDetails(dynamic data) async {
  final deviceDetail = jsonEncode(await DeviceInfo.getDetail());
  return deviceDetail;
}

logout(BuildContext context) {
  AppSession().loginUser = null;
  WebViewControllerUtils.controller?.webStorage.localStorage.clear();
  Navigator.pushNamedAndRemoveUntil(context, Routes.login, (route) => false);
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

getCurrentUser() async {
  final currentUser = await AppSession().loginUser;
  return currentUser;
}

updateUserDetail(data) async {
  if (data.isNotEmpty) {
    final userData = data[0];
    if (userData != null) {
      AppSession().loginUser = jsonEncode(userData);
    }
  }
}

showToastMessage(data){
  if (data.isNotEmpty) {
    ToastMessage.show(data[0]);
  }
}

showErrorMessage(data){
  if (data.isNotEmpty) {
    ToastMessage.error(data[0]);
  }
}
