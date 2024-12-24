import 'package:base_mobile_app/models/auth/login_request.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DeviceInfo {
  static Future<DeviceDetails?> getDetail() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;
        return DeviceDetails(
            androidAPILevel: "${androidDeviceInfo.version.sdkInt}",
            os: 'Android',
            uniqueId: androidDeviceInfo.id,
            osVersion: androidDeviceInfo.version.release,
            name: androidDeviceInfo.device,
            model: androidDeviceInfo.model,
            manufacturer: androidDeviceInfo.manufacturer,
            appVersion: packageInfo.version,
            buildNumber: packageInfo.buildNumber,
            timeZone: "");
      case TargetPlatform.fuchsia:
      // TODO: Handle this case.
      case TargetPlatform.iOS:
        IosDeviceInfo iosDeviceInfo = await deviceInfoPlugin.iosInfo;
        return DeviceDetails(
            androidAPILevel: iosDeviceInfo.utsname.version,
            os: 'IOS',
            uniqueId: iosDeviceInfo.identifierForVendor,
            osVersion: iosDeviceInfo.utsname.release,
            name: iosDeviceInfo.name,
            model: iosDeviceInfo.model,
            manufacturer: iosDeviceInfo.systemName,
            appVersion: packageInfo.version,
            buildNumber: packageInfo.buildNumber,
            timeZone: "");
      case TargetPlatform.linux:
      // TODO: Handle this case.
      case TargetPlatform.macOS:
      // TODO: Handle this case.
      case TargetPlatform.windows:
      // TODO: Handle this case.
    }
    return null;
  }
}
