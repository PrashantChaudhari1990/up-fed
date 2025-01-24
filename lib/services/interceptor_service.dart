import 'dart:convert';
import 'dart:io';
import 'package:kh_dealer_app/config/server_config.dart';
import 'package:kh_dealer_app/constant/common_constants.dart';
import 'package:kh_dealer_app/models/user.dart';
import 'package:kh_dealer_app/utils/app_loader.dart';
import 'package:kh_dealer_app/utils/app_session.dart';
import 'package:kh_dealer_app/utils/toast_message.dart';
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
        if(dioException.type == DioExceptionType.connectionError){
          ToastMessage.show('No internet connection.');
        }else if(dioException.response?.statusCode == 500){
          ToastMessage.show(dioException.response?.data?['message']);
        }else if(dioException.response?.statusCode == 400){
          ToastMessage.show(dioException.response?.data?['message']);
        }else if(dioException.error.runtimeType == SocketException){
          ToastMessage.show((dioException.error as SocketException).message);
        }else if(dioException.response?.statusCode == 401){
          ToastMessage.show(dioException.response?.data?['message']);
        }
        try{
          errorInterceptorHandler.next(dioException);
        }catch(e){}
      }
    ));
  }
}