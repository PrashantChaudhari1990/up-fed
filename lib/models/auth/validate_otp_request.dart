import 'login_request.dart';

class ValidateOtpRequest {
  String? phoneNumber;
  String? otp;
  bool? flag;
  DeviceDetails? deviceDetail;

  ValidateOtpRequest({this.phoneNumber, this.otp, this.flag, this.deviceDetail});

  ValidateOtpRequest.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phoneNumber'];
    otp = json['otp'];
    flag = json['flag'];
    deviceDetail = json['deviceDetail'] != null
        ? DeviceDetails.fromJson(json['deviceDetail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phoneNumber'] = phoneNumber;
    data['otp'] = otp;
    data['flag'] = flag;
    if (deviceDetail != null) {
      data['deviceDetail'] = deviceDetail!.toJson();
    }
    return data;
  }
}
