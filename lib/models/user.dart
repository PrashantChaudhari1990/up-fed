class User {
  int? id;
  String? username;
  String? email;
  String? sessionToken;
  String? phoneNumber;
  String? firstName;
  String? userType;
  DeviceDetail? deviceDetail;
  List<String>? authorities;
  int? clientId;
  List<String>? userRoles;
  List<String>? scopes;
  String? refreshToken;
  int? sessionExpire;
  int? refreshExpire;
  bool? validUserDetails;

  User(
      {this.id,
        this.username,
        this.email,
        this.sessionToken,
        this.phoneNumber,
        this.firstName,
        this.userType,
        this.deviceDetail,
        this.authorities,
        this.clientId,
        this.userRoles,
        this.scopes,
        this.refreshToken,
        this.sessionExpire,
        this.refreshExpire,
        this.validUserDetails});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    sessionToken = json['sessionToken'];
    phoneNumber = json['phoneNumber'];
    firstName = json['firstName'];
    userType = json['userType'];
    deviceDetail = json['deviceDetail'] != null
        ? new DeviceDetail.fromJson(json['deviceDetail'])
        : null;
    authorities = json['authorities']!=null?json['authorities'].cast<String>():[];
    clientId = json['clientId'];
    userRoles = json['userRoles']!=null? json['userRoles'].cast<String>():[];
    scopes =  json['scopes']!=null?json['scopes'].cast<String>():[];
    refreshToken = json['refreshToken'];
    sessionExpire = json['sessionExpire'];
    refreshExpire = json['refreshExpire'];
    validUserDetails = json['validUserDetails'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['sessionToken'] = this.sessionToken;
    data['phoneNumber'] = this.phoneNumber;
    data['firstName'] = this.firstName;
    data['userType'] = this.userType;
    if (this.deviceDetail != null) {
      data['deviceDetail'] = this.deviceDetail!.toJson();
    }
    data['authorities'] = this.authorities;
    data['clientId'] = this.clientId;
    data['userRoles'] = this.userRoles;
    data['scopes'] = this.scopes;
    data['refreshToken'] = this.refreshToken;
    data['sessionExpire'] = this.sessionExpire;
    data['refreshExpire'] = this.refreshExpire;
    data['validUserDetails'] = this.validUserDetails;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['appVersion'] = this.appVersion;
    data['buildNumber'] = this.buildNumber;
    data['manufacturer'] = this.manufacturer;
    data['model'] = this.model;
    data['name'] = this.name;
    data['osVersion'] = this.osVersion;
    data['timeZone'] = this.timeZone;
    data['androidAPILevel'] = this.androidAPILevel;
    data['uniqueId'] = this.uniqueId;
    data['os'] = this.os;
    return data;
  }
}