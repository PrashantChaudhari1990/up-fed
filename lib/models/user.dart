class User {
  bool? success;
  String? message;
  Data? data;

  User({this.success, this.message, this.data});

  User.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? otpId;
  String? status;
  LoginResponse? loginResponse;
  bool? newUser;

  Data({this.otpId, this.status, this.loginResponse, this.newUser});

  Data.fromJson(Map<String, dynamic> json) {
    otpId = json['otpId'];
    status = json['status'];
    loginResponse = json['loginResponse'] != null
        ? new LoginResponse.fromJson(json['loginResponse'])
        : null;
    newUser = json['newUser'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['otpId'] = this.otpId;
    data['status'] = this.status;
    if (this.loginResponse != null) {
      data['loginResponse'] = this.loginResponse!.toJson();
    }
    data['newUser'] = this.newUser;
    return data;
  }
}
class LoginResponse {
  int? userId;
  bool? existingUser;
  String? sessionToken;
  bool? validUserDetails;
  String? refreshToken;
  int? sessionExpire;
  int? refreshExpire;
  int? companyId;
  String? companyName;
  String? userName;
  String? mobileNumber;

  LoginResponse(
      {this.userId,
        this.existingUser,
        this.sessionToken,
        this.validUserDetails,
        this.refreshToken,
        this.sessionExpire,
        this.refreshExpire,
        this.companyId,
        this.mobileNumber,
        this.userName,
        this.companyName});

  LoginResponse.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    existingUser = json['existingUser'];
    sessionToken = json['sessionToken'];
    validUserDetails = json['validUserDetails'];
    refreshToken = json['refreshToken'];
    sessionExpire = json['sessionExpire'];
    refreshExpire = json['refreshExpire'];
    companyId = json['companyId'];
    companyName = json['companyName'];
    userName = json['userName'];
    mobileNumber = json['mobileNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['existingUser'] = this.existingUser;
    data['sessionToken'] = this.sessionToken;
    data['validUserDetails'] = this.validUserDetails;
    data['refreshToken'] = this.refreshToken;
    data['sessionExpire'] = this.sessionExpire;
    data['refreshExpire'] = this.refreshExpire;
    data['companyId'] = this.companyId;
    data['companyName'] = this.companyName;
    data['userName'] = this.userName;
    data['mobileNumber'] = this.mobileNumber;
    return data;
  }
}

class DeviceDetail {
  String? appVersion;
  String? buildNumber;
  String? manufacturer;
  String? model;
  String? name;
  String? osVersion;
  String? timeZone;
  String? androidAPILevel;
  String? uniqueId;
  String? os;

  DeviceDetail(
      {this.appVersion,
      this.buildNumber,
      this.manufacturer,
      this.model,
      this.name,
      this.osVersion,
      this.timeZone,
      this.androidAPILevel,
      this.uniqueId,
      this.os});

  DeviceDetail.fromJson(Map<String, dynamic> json) {
    appVersion = json['appVersion'];
    buildNumber = json['buildNumber'];
    manufacturer = json['manufacturer'];
    model = json['model'];
    name = json['name'];
    osVersion = json['osVersion'];
    timeZone = json['timeZone'];
    androidAPILevel = json['androidAPILevel'];
    uniqueId = json['uniqueId'];
    os = json['os'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['appVersion'] = appVersion;
    data['buildNumber'] = buildNumber;
    data['manufacturer'] = manufacturer;
    data['model'] = model;
    data['name'] = name;
    data['osVersion'] = osVersion;
    data['timeZone'] = timeZone;
    data['androidAPILevel'] = androidAPILevel;
    data['uniqueId'] = uniqueId;
    data['os'] = os;
    return data;
  }
}
