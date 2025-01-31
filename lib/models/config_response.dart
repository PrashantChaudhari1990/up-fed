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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['keyName'] = keyName;
    data['value'] = value;
    data['details'] = details;
    data['dataType'] = dataType;
    return data;
  }
}
