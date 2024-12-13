class SliderDetails {
  String? imageUrl;
  String? description;

  SliderDetails({this.imageUrl, this.description});

  SliderDetails.fromJson(Map<String, dynamic> json) {
    imageUrl = json['imageUrl'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['imageUrl'] = imageUrl;
    data['description'] = description;
    return data;
  }
}
