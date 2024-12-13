import 'dart:ffi';

class ValidateOtpRequest {
  String? phoneNumber;
  String? otp;
  Bool? flag;
  String? fcmToken;

  ValidateOtpRequest({this.phoneNumber, this.otp, this.flag, this.fcmToken});

  ValidateOtpRequest.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phoneNumber'];
    otp = json['otp'];
    flag = json['flag'];
    fcmToken = json['fcmToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['phoneNumber'] = this.phoneNumber;
    data['otp'] = this.otp;
    data['flag'] = this.flag;
    data['fcmToken'] = this.fcmToken;
    return data;
  }
}
