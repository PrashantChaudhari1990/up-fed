import 'package:base_mobile_app/config/server_config.dart';
import 'package:base_mobile_app/constant/common_constants.dart';
import 'package:base_mobile_app/utils/app_loader.dart';
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
      onRequest:(requestOptions,requestInterceptorHandler){
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
        return;
        // return errorInterceptorHandler.next(dioException);
      }
    ));
  }
}