import 'package:kh_dealer_app/constant/api_end_points.dart';
import 'package:kh_dealer_app/services/interceptor_service.dart';
import 'package:dio/dio.dart';

class CommonService{

  final dio = InterceptorService().dio;

  Future getConfigByKey(String key, {bool showLoader = false}) async {
    return dio.get("${ApiEndPoints.config}/$key",options: Options(extra: {'showLoader':showLoader}));
  }
}