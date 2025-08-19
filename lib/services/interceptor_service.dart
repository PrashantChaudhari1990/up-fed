import 'dart:convert';
import 'dart:io';
import 'package:mhassoc_ui/config/server_config.dart';
import 'package:mhassoc_ui/constant/common_constants.dart';
import 'package:mhassoc_ui/models/user.dart';
import 'package:mhassoc_ui/utils/app_loader.dart';
import 'package:mhassoc_ui/utils/app_session.dart';
import 'package:mhassoc_ui/utils/toast_message.dart';
import 'package:dio/dio.dart';

class InterceptorService {
  static final InterceptorService _instance = InterceptorService._internal();
  factory InterceptorService() => _instance;
  InterceptorService._internal();

  Dio dio = Dio(BaseOptions(
      baseUrl: environment.baseUrl,
      contentType: "application/json",
      headers: {
        "x-visibility-scope": CommonConstants.xVisibilityScope,
        "x-tenant-id": CommonConstants.tenantId
      }));

  ///[initialize] method call in main.dart file at the starting.
  initialize() {
    dio.interceptors.add(InterceptorsWrapper(
        onRequest: (requestOptions, requestInterceptorHandler) async {
      final loginUser = await AppSession().loginUser;
      requestOptions.headers['x-tenant-id'] = CommonConstants.tenantId;
      if (loginUser != null) {
        User user = User.fromJson(jsonDecode(loginUser));
        requestOptions.headers['Authorization'] = 'Bearer ${user.data!.loginResponse!.sessionToken}';
      }
      if (requestOptions.extra['showLoader'] ?? true) {
        AppLoader().show();
      }
      requestInterceptorHandler.next(requestOptions);
    }, onResponse: (response, responseInterceptorHandler) {
      if (response.requestOptions.extra['showLoader'] ?? true) {
        AppLoader().hide();
      }
      responseInterceptorHandler.next(response);
    }, onError: (dioException, errorInterceptorHandler) {
      if (dioException.requestOptions.extra['showLoader'] ?? true) {
        AppLoader().hide();
      }
      if (dioException.type == DioExceptionType.connectionError) {
        ToastMessage.show('No internet connection.');
      } else if (dioException.response?.statusCode == 500) {
        ToastMessage.show(dioException.response?.data?['message']);
      } else if (dioException.response?.statusCode == 400) {
        ToastMessage.show(dioException.response?.data?['message']);
      } else if (dioException.error.runtimeType == SocketException) {
        ToastMessage.show((dioException.error as SocketException).message);
      } else if (dioException.response?.statusCode == 401) {
        ToastMessage.show(dioException.response?.data?['message']);
      }
      try {
        errorInterceptorHandler.next(dioException);
      } catch (e) {
        // Error handler execution failed - ignore to prevent cascade errors
      }
    }));
  }
}
