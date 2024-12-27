import 'dart:convert';
import 'dart:io';
import 'package:base_mobile_app/config/server_config.dart';
import 'package:base_mobile_app/constant/common_constants.dart';
import 'package:base_mobile_app/models/user.dart';
import 'package:base_mobile_app/utils/app_loader.dart';
import 'package:base_mobile_app/utils/app_session.dart';
import 'package:base_mobile_app/utils/toast_message.dart';
import 'package:dio/dio.dart';

class InterceptorService{
  static final InterceptorService _instance = InterceptorService._internal();
  factory InterceptorService() => _instance;
  InterceptorService._internal();

  Dio dio = Dio(BaseOptions(
      baseUrl: environment.baseUrl,
      contentType: "application/json",
    headers: {
        "x-visibility-scope": CommonConstants.xVisibilityScope,
        "x-tenant-id": CommonConstants.xTenantId
    }
  ));

  ///[initialize] method call in main.dart file at the starting.
  initialize(){
    dio.interceptors.add(InterceptorsWrapper(
      onRequest:(requestOptions,requestInterceptorHandler) async {
        final loginUser = await AppSession().loginUser;
        if(loginUser!=null){
          User user = User.fromJson(jsonDecode(loginUser));
          requestOptions.headers['Authorization'] = 'Bearer ${user.sessionToken}';
        }
        if(requestOptions.extra['showLoader']??true){
          AppLoader().show();
        }
        requestInterceptorHandler.next(requestOptions);
      },
      onResponse: (response,responseInterceptorHandler){
        if(response.requestOptions.extra['showLoader']??true){
          AppLoader().hide();
        }
        responseInterceptorHandler.next(response);
      },
      onError: (dioException,errorInterceptorHandler){
        if(dioException.requestOptions.extra['showLoader']??true){
          AppLoader().hide();
        }
        if(dioException.response?.statusCode == 500){
          ToastMessage.show(dioException.response?.data?['message']);
          return dioException.response?.data;
        }else if(dioException.error.runtimeType == SocketException){
          ToastMessage.show((dioException.error as SocketException).message);
        }
        try{
          errorInterceptorHandler.next(dioException);
        }catch(e){}
      }
    ));
  }
}