class PreLoginResponse {
  String? status;
  int? statusCode;
  String? message;
  List<UserData>? data;

  PreLoginResponse({this.status, this.statusCode, this.message, this.data});

  PreLoginResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['statusCode'];
    message = json['message'];
    if (json['data'] != null) {
      data = <UserData>[];
      json['data'].forEach((v) {
        data!.add(UserData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['statusCode'] = statusCode;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class UserData {
  int? id;
  String? username;
  String? email;
  String? phoneNumber;
  String? firstName;
  String? lastName;
  String? userType;
  List<dynamic>? authorities;
  int? clientId;
  int? sessionExpire;
  int? refreshExpire;
  int? tenantId;
  String? tenantName;
  bool? validUserDetails;

  UserData({
    this.id,
    this.username,
    this.email,
    this.phoneNumber,
    this.firstName,
    this.lastName,
    this.userType,
    this.authorities,
    this.clientId,
    this.sessionExpire,
    this.refreshExpire,
    this.tenantId,
    this.tenantName,
    this.validUserDetails,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    userType = json['userType'];
    if (json['authorities'] != null) {
      authorities = json['authorities'];
    }
    clientId = json['clientId'];
    sessionExpire = json['sessionExpire'];
    refreshExpire = json['refreshExpire'];
    tenantId = json['tenantId'];
    tenantName = json['tenantName'];
    validUserDetails = json['validUserDetails'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['email'] = email;
    data['phoneNumber'] = phoneNumber;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['userType'] = userType;
    data['authorities'] = authorities;
    data['clientId'] = clientId;
    data['sessionExpire'] = sessionExpire;
    data['refreshExpire'] = refreshExpire;
    data['tenantId'] = tenantId;
    data['tenantName'] = tenantName;
    data['validUserDetails'] = validUserDetails;
    return data;
  }
}
