import 'package:flutter/cupertino.dart';
import 'package:bttoa_ui/constant/api_end_points.dart';
import 'package:bttoa_ui/models/auth/generate_otp_request.dart';
import 'package:bttoa_ui/models/auth/login_request.dart';
import 'package:bttoa_ui/models/auth/set_pin_request.dart';
import 'package:bttoa_ui/models/auth/validate_otp_request.dart';
import 'package:bttoa_ui/services/interceptor_service.dart';
import 'package:dio/dio.dart';

class AuthService {
  final _interceptorService = InterceptorService();

  dynamic preLogin(BuildContext context, String username) async {
    String preLoginUrl = '/api/pre-login/$username/byUsername';
    return _interceptorService.dio.get(preLoginUrl,
        options: Options(
          extra: {'context': context},
          //headers: {'x-visibility-scope': Constants.xVisibilityScope}
        ));
  }

  dynamic sliderImages(BuildContext context) async {
    String preLoginUrl = '/api/config/global/SLIDER_IMAGES/parsed';
    return _interceptorService.dio.get(preLoginUrl,
        options: Options(
          extra: {'context': context},
          //headers: {'x-visibility-scope': Constants.xVisibilityScope}
        ));
  }

  Future generateOtp(GenerateOtpRequest generateOtpRequest) async {
    return _interceptorService.dio
        .post(ApiEndPoints.generateOtp, data: generateOtpRequest);
  }

  Future resendOtp(GenerateOtpRequest generateOtpRequest) async {
    return _interceptorService.dio
        .post(ApiEndPoints.resendOtp, data: generateOtpRequest);
  }

  Future forgotPin(GenerateOtpRequest generateOtpRequest) async {
    return _interceptorService.dio
        .post(ApiEndPoints.forgotPin, data: generateOtpRequest);
  }

  Future validateOtp(ValidateOtpRequest validateOtpRequest) async {
    return _interceptorService.dio
        .post(ApiEndPoints.validateOtp, data: validateOtpRequest);
  }

  Future login(LoginRequest loginRequest) async {
    return _interceptorService.dio.post(ApiEndPoints.login, data: loginRequest);
  }

  Future setPin(SetPinRequest setPinRequest, String? token) async {
    return _interceptorService.dio.post(ApiEndPoints.setPin,
        data: setPinRequest,
        options: Options(headers: {'Authorization': 'Bearer $token'}));
  }
}
