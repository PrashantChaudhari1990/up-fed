class ValidateOtpResponse {
  int? id;
  int? userId;
  String? username;
  String? email;
  String? sessionToken;
  String? phoneNumber;
  String? firstName;
  String? lastName;
  int? clientId;
  int? flag;
  String? refreshToken;
  int? sessionExpire;
  int? refreshExpire;
  String? userType;
  List<String>? authorities;
  List<String>? scopes;
  List<String>? userRoles;

  ValidateOtpResponse(
      {this.id,
        this.userId,
        this.username,
        this.email,
        this.sessionToken,
        this.phoneNumber,
        this.firstName,
        this.lastName,
        this.clientId,
        this.flag,
        this.refreshToken,
        this.sessionExpire,
        this.refreshExpire,
        this.userType,
        this.authorities,
        this.scopes,
        this.userRoles});

  ValidateOtpResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    username = json['username'];
    email = json['email'];
    sessionToken = json['sessionToken'];
    phoneNumber = json['phoneNumber'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    clientId = json['clientId'];
    flag = json['flag'];
    refreshToken = json['refreshToken'];
    sessionExpire = json['sessionExpire'];
    refreshExpire = json['refreshExpire'];
    userType = json['userType'];
    authorities = json['authorities'].cast<String>();
    scopes = json['scopes'].cast<String>();
    userRoles = json['userRoles'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['userId'] = userId;
    data['username'] = username;
    data['email'] = email;
    data['sessionToken'] = sessionToken;
    data['phoneNumber'] = phoneNumber;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['clientId'] = clientId;
    data['flag'] = flag;
    data['refreshToken'] = refreshToken;
    data['sessionExpire'] = sessionExpire;
    data['refreshExpire'] = refreshExpire;
    data['userType'] = userType;
    data['authorities'] = scopes;
    data['scopes'] = scopes;
    data['userRoles'] = userRoles;
    return data;
  }
}