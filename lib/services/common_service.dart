import 'package:base_mobile_app/services/interceptor_service.dart';

class CommonService{

  final dio = InterceptorService().dio;

  Future getUiConstantByKey(String key) async {
    return dio.get("uiConstant/$key.json");
  }

}