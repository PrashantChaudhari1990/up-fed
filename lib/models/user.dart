class User {
  int? userId;
  String? username;
  String? phoneNumber1;
  String? email;
  bool? existingUser;
  String? sessionToken;
  String? fullName;
  bool? validUserDetails;
  dynamic sessionExpire;
  dynamic refreshExpire;
  List<String>? authorities;

  User(
      {this.userId,
        this.username,
        this.phoneNumber1,
        this.email,
        this.existingUser,
        this.sessionToken,
        this.fullName,
        this.validUserDetails,
        this.sessionExpire,
        this.refreshExpire,
        this.authorities});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    username = json['username'];
    phoneNumber1 = json['phoneNumber1'];
    email = json['email'];
    existingUser = json['existingUser'];
    sessionToken = json['sessionToken'];
    fullName = json['fullName'];
    validUserDetails = json['validUserDetails'];
    sessionExpire = json['sessionExpire'];
    refreshExpire = json['refreshExpire'];
    authorities = json['authorities']?.cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = userId;
    data['username'] = username;
    data['phoneNumber1'] = phoneNumber1;
    data['email'] = email;
    data['existingUser'] = existingUser;
    data['sessionToken'] = sessionToken;
    data['fullName'] = fullName;
    data['validUserDetails'] = validUserDetails;
    data['sessionExpire'] = sessionExpire;
    data['refreshExpire'] = refreshExpire;
    data['authorities'] = authorities;
    return data;
  }
}
