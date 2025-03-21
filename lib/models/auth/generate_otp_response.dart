class GenerateOtpResponse {
  String? otp;
  String? id;
  String? phoneNumber;
  bool? existingUser;

  GenerateOtpResponse({this.otp, this.phoneNumber, this.existingUser});

  GenerateOtpResponse.fromJson(Map<String, dynamic> json) {
    otp = json['otp'];
    phoneNumber = json['phoneNumber'];
    existingUser = json['existingUser'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['otp'] = otp;
    data['phoneNumber'] = phoneNumber;
    data['existingUser'] = existingUser;
    return data;
  }
}
