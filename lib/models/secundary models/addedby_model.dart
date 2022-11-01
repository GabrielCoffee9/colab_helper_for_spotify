import 'package:colab_helper_for_spotify/models/secundary%20models/external_urls_model.dart';

class AddedBy {
  ExternalUrls? externalUrls;
  String? href;
  String? id;
  String? type;
  String? uri;

  AddedBy({this.externalUrls, this.href, this.id, this.type, this.uri});

  AddedBy.fromJson(Map<String, dynamic> json) {
    externalUrls = json['external_urls'] != null
        ? ExternalUrls.fromJson(json['external_urls'])
        : null;
    href = json['href'];
    id = json['id'];
    type = json['type'];
    uri = json['uri'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (externalUrls != null) {
      data['external_urls'] = externalUrls!.toJson();
    }
    data['href'] = href;
    data['id'] = id;
    data['type'] = type;
    data['uri'] = uri;
    return data;
  }
}
