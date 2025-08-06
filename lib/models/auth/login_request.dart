class LoginRequest {
  String? username;
  String? password;
  DeviceDetails? deviceDetail;

  LoginRequest({this.username, this.password, this.deviceDetail});

  LoginRequest.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    password = json['password'];
    deviceDetail = json['deviceDetail'] != null
        ? DeviceDetails.fromJson(json['deviceDetail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['username'] = username;
    data['password'] = password;
    if (deviceDetail != null) {
      data['deviceDetail'] = deviceDetail!.toJson();
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
  String? fcmToken;

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
      this.androidAPILevel,
      this.fcmToken});

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
    fcmToken = json['fcmToken'];
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
    data['fcmToken'] = fcmToken;
    return data;
  }
}
