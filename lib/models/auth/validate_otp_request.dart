import 'login_request.dart';

class ValidateOtpRequest {
  String? mobileNumber;
  bool? flag;
  DeviceDetails? deviceDetail;
  String? userId;
  String? otpCode;

  ValidateOtpRequest(
      {this.mobileNumber, this.otpCode, this.flag, this.deviceDetail, this.userId});

  ValidateOtpRequest.fromJson(Map<String, dynamic> json) {
    mobileNumber = json['mobileNumber'];
    otpCode = json['otpCode'];
    flag = json['flag'];
    userId = json['userId'];
    deviceDetail = json['deviceDetail'] != null
        ? DeviceDetails.fromJson(json['deviceDetail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mobileNumber'] = mobileNumber;
    data['otpCode'] = otpCode;
    data['userId'] = userId;
    data['flag'] = flag;
    if (deviceDetail != null) {
      data['deviceDetail'] = deviceDetail!.toJson();
    }
    return data;
  }
}
