abstract class ApiEndPoints {
  static const generateOtp = '/api/auth/otp/generate';
  static const validateOtp = '/api/auth/otp/validate';
  static const login = '/api/auth/login/pin';
  static const config = '/api/config/by-key-parsed/vpaSliderImages';
  static const forgotPin = '/user/password/forgot';
  static const setPin = '/user/password/set';
  static const resendOtp = '/api/auth/otp/resend';

  /// App auto update check endpoint
  /// Response: { "success": true, "data": true }
  static const appAutoUpdate = '/api/config/tenant/APP_AUTO_UPDATE_ENABLED/parsed';
}
