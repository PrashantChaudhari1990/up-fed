import 'package:base_mobile_app/constant/api_end_points.dart';
import 'package:base_mobile_app/services/interceptor_service.dart';

class CommonService{

  final dio = InterceptorService().dio;

  Future getConfigByKey(String key) async {
    return dio.get("${ApiEndPoints.config}/$key");
  }
}