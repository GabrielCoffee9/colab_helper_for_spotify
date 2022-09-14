class ExternalUrlsModel {
  String? spotify;

  ExternalUrlsModel({this.spotify});

  ExternalUrlsModel.fromJson(Map<String, dynamic> json) {
    spotify = json['spotify'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['spotify'] = spotify;
    return data;
  }
}
