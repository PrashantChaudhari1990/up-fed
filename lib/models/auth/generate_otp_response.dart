class GenerateOtpResponse {
  String? otp;
  String? phoneNumber;
  bool? flag;

  GenerateOtpResponse({this.otp, this.phoneNumber, this.flag});

  GenerateOtpResponse.fromJson(Map<String, dynamic> json) {
    otp = json['otp'];
    phoneNumber = json['phoneNumber'];
    flag = json['flag'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otp'] = this.otp;
    data['phoneNumber'] = this.phoneNumber;
    data['flag'] = this.flag;
    return data;
  }
}
