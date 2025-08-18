class GenerateOtpRequest {
  String? mobileNumber;

  GenerateOtpRequest({this.mobileNumber});

  GenerateOtpRequest.fromJson(Map<String, dynamic> json) {
    mobileNumber = json['mobileNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['mobileNumber'] = mobileNumber;
    return data;
  }
}
