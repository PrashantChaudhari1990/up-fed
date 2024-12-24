import 'package:base_mobile_app/constant/api_end_points.dart';
import 'package:base_mobile_app/models/auth/generate_otp_request.dart';
import 'package:base_mobile_app/models/auth/login_request.dart';
import 'package:base_mobile_app/models/auth/validate_otp_request.dart';
import 'package:base_mobile_app/services/interceptor_service.dart';

class AuthService{
  final _interceptorService = InterceptorService();

  Future generateOtp(GenerateOtpRequest generateOtpRequest) async {
    return _interceptorService.dio.post(ApiEndPoints.generateOtp,data: generateOtpRequest);
  }

  Future validateOtp(ValidateOtpRequest validateOtpRequest) async {
    return _interceptorService.dio.post(ApiEndPoints.validateOtp,data: validateOtpRequest);
  }
  Future login(LoginRequest loginRequest) async {
    return _interceptorService.dio.post(ApiEndPoints.login,data: loginRequest);
  }

}