class Images {
  String? url;
  int? height;
  int? width;

  Images({this.url, this.height, this.width});

  Images.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    height = json['height'];
    width = json['width'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url ?? '';
    data['height'] = height ?? '';
    data['width'] = width ?? '';
    return data;
  }
}
