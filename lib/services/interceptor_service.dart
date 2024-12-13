import 'package:base_mobile_app/config/server_config.dart';
import 'package:dio/dio.dart';

class InterceptorService{
  static final InterceptorService _instance = InterceptorService._internal();
  factory InterceptorService() => _instance;
  InterceptorService._internal();

  Dio dio = Dio(BaseOptions(
      baseUrl: environment.baseUrl,
      contentType: "application/json",
    headers: {
        "x-visibility-scope":"M-PORTAL",
      "x-tenant-id":1
    }
  ));

  ///[initialize] method call in main.dart file at the starting.
  initialize(){
    dio.interceptors.add(InterceptorsWrapper(
      onRequest:(requestOptions,requestInterceptorHandler){
        requestInterceptorHandler.next(requestOptions);
      },
      onResponse: (response,responseInterceptorHandler){
        responseInterceptorHandler.next(response);
      },
      onError: (dioException,errorInterceptorHandler){
        return;
        // errorInterceptorHandler.next(dioException);
      }
    ));
  }

}