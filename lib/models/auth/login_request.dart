class LoginRequest {
  String? username;
  String? password;
  DeviceDetails? deviceDetails;

  LoginRequest({this.username, this.password, this.deviceDetails});

  LoginRequest.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
    deviceDetails = json['deviceDetails'] != null
        ? new DeviceDetails.fromJson(json['deviceDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['password'] = this.password;
    if (this.deviceDetails != null) {
      data['deviceDetails'] = this.deviceDetails!.toJson();
    }
    return data;
  }
}

class DeviceDetails {
  String? os;
  String? name;
  String? model;
  String? timeZone;
  String? uniqueId;
  String? osVersion;
  String? appVersion;
  String? buildNumber;
  String? manufacturer;
  String? androidAPILevel;

  DeviceDetails(
      {this.os,
        this.name,
        this.model,
        this.timeZone,
        this.uniqueId,
        this.osVersion,
        this.appVersion,
        this.buildNumber,
        this.manufacturer,
        this.androidAPILevel});

  DeviceDetails.fromJson(Map<String, dynamic> json) {
    os = json['os'];
    name = json['name'];
    model = json['model'];
    timeZone = json['timeZone'];
    uniqueId = json['uniqueId'];
    osVersion = json['osVersion'];
    appVersion = json['appVersion'];
    buildNumber = json['buildNumber'];
    manufacturer = json['manufacturer'];
    androidAPILevel = json['androidAPILevel'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['os'] = this.os;
    data['name'] = this.name;
    data['model'] = this.model;
    data['timeZone'] = this.timeZone;
    data['uniqueId'] = this.uniqueId;
    data['osVersion'] = this.osVersion;
    data['appVersion'] = this.appVersion;
    data['buildNumber'] = this.buildNumber;
    data['manufacturer'] = this.manufacturer;
    data['androidAPILevel'] = this.androidAPILevel;
    return data;
  }
}
