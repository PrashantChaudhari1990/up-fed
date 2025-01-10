class ConfigResponse {
  int? id;
  String? keyName;
  dynamic value;
  String? details;
  String? dataType;

  ConfigResponse(
      {this.id, this.keyName, this.value, this.details, this.dataType});

  ConfigResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    keyName = json['keyName'];
    value = json['value'];
    details = json['details'];
    dataType = json['dataType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['keyName'] = this.keyName;
    data['value'] = this.value;
    data['details'] = this.details;
    data['dataType'] = this.dataType;
    return data;
  }
}
