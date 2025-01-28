import 'login_request.dart';

class ValidateOtpRequest {
  String? phoneNumber;
  String? otp;
  bool? flag;
  DeviceDetails? deviceDetails;

  ValidateOtpRequest({this.phoneNumber, this.otp, this.flag, this.deviceDetails});

  ValidateOtpRequest.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phoneNumber'];
    otp = json['otp'];
    flag = json['flag'];
    deviceDetails = json['deviceDetails'] != null
        ? DeviceDetails.fromJson(json['deviceDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phoneNumber'] = phoneNumber;
    data['otp'] = otp;
    data['flag'] = flag;
    if (deviceDetails != null) {
      data['deviceDetails'] = deviceDetails!.toJson();
    }
    return data;
  }
}
