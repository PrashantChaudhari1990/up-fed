class LoginRequest {
  String? username;
  String? password;
  DeviceDetails? deviceDetails;

  LoginRequest({this.username, this.password, this.deviceDetails});

  LoginRequest.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
    deviceDetails = json['deviceDetails'] != null
        ? DeviceDetails.fromJson(json['deviceDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['password'] = password;
    if (deviceDetails != null) {
      data['deviceDetails'] = deviceDetails!.toJson();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['os'] = os;
    data['name'] = name;
    data['model'] = model;
    data['timeZone'] = timeZone;
    data['uniqueId'] = uniqueId;
    data['osVersion'] = osVersion;
    data['appVersion'] = appVersion;
    data['buildNumber'] = buildNumber;
    data['manufacturer'] = manufacturer;
    data['androidAPILevel'] = androidAPILevel;
    return data;
  }
}
