class SetPinRequest {
  String? phoneNumber;
  String? email;
  String? password;
  String? otp;

  SetPinRequest({this.phoneNumber, this.email, this.password, this.otp});

  SetPinRequest.fromJson(Map<String, dynamic> json) {
    phoneNumber = json['phoneNumber'];
    email = json['email'];
    password = json['password'];
    otp = json['otp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['phoneNumber'] = phoneNumber;
    data['email'] = email;
    data['password'] = password;
    data['otp'] = otp;
    return data;
  }
}
