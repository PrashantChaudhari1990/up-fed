import 'package:base_mobile_app/constant/api_end_points.dart';
import 'package:base_mobile_app/models/auth/generate_otp_request.dart';
import 'package:base_mobile_app/models/auth/login_request.dart';
import 'package:base_mobile_app/models/auth/set_pin_request.dart';
import 'package:base_mobile_app/models/auth/validate_otp_request.dart';
import 'package:base_mobile_app/services/interceptor_service.dart';
import 'package:dio/dio.dart';

class AuthService{
  final _interceptorService = InterceptorService();

  Future generateOtp(GenerateOtpRequest generateOtpRequest) async {
    return _interceptorService.dio.post(ApiEndPoints.generateOtp,data: generateOtpRequest);
  }
  Future forgotPin(GenerateOtpRequest generateOtpRequest) async {
    return _interceptorService.dio.post(ApiEndPoints.forgotPin,data: generateOtpRequest);
  }

  Future validateOtp(ValidateOtpRequest validateOtpRequest) async {
    return _interceptorService.dio.post(ApiEndPoints.validateOtp,data: validateOtpRequest);
  }
  Future login(LoginRequest loginRequest) async {
    return _interceptorService.dio.post(ApiEndPoints.login,data: loginRequest);
  }
  Future setPin(SetPinRequest setPinRequest,String? token) async {
    return _interceptorService.dio.post(ApiEndPoints.setPin,data: setPinRequest,options: Options(headers: {'Authorization' :'Bearer $token'}));
  }

}