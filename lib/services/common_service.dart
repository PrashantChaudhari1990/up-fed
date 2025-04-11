import 'package:vendor_partner/constant/api_end_points.dart';
import 'package:vendor_partner/services/interceptor_service.dart';
import 'package:dio/dio.dart';

class CommonService{

  final dio = InterceptorService().dio;

  Future getConfigByKey({bool showLoader = false}) async {
    return dio.get(ApiEndPoints.config,options: Options(extra: {'showLoader':showLoader}));
  }
}