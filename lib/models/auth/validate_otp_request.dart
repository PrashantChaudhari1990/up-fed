import 'login_request.dart';

class ValidateOtpRequest {
  String? phoneNumber;
  String? otp;
  bool? flag;
  DeviceDetails? deviceDetail;
  String? id;

  ValidateOtpRequest({this.phoneNumber, this.otp, this.flag, this.deviceDetail,this.id});

  ValidateOtpRequest.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phoneNumber'];
    otp = json['otp'];
    flag = json['flag'];
    id = json['id'];
    deviceDetail = json['deviceDetail'] != null
        ? DeviceDetails.fromJson(json['deviceDetail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phoneNumber'] = phoneNumber;
    data['otp'] = otp;
    data['id'] = id;
    data['flag'] = flag;
    if (deviceDetail != null) {
      data['deviceDetail'] = deviceDetail!.toJson();
    }
    return data;
  }
}
