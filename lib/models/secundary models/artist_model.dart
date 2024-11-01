import 'external_urls_model.dart';
import 'images_model.dart';

class Artist {
  ExternalUrls? externalUrls;
  String? href;
  String? id;
  String? name;
  String? type;
  String? uri;
  List<Images> images = <Images>[];
  int? popularity;
  List<String> genres = <String>[];

  Artist({
    this.externalUrls,
    this.href,
    this.id,
    this.name,
    this.type,
    this.uri,
    this.images = const <Images>[],
    this.genres = const <String>[],
    this.popularity,
  });

  Artist.fromJson(Map<String, dynamic> json) {
    externalUrls = json['external_urls'] != null
        ? ExternalUrls.fromJson(json['external_urls'])
        : null;
    href = json['href'];
    id = json['id'];
    name = json['name'];
    type = json['type'];
    uri = json['uri'];

    popularity = json['popularity'];

    if (json['images'] != null) {
      json['images'].forEach((v) {
        images.add(Images.fromJson(v));
      });
    }

    if (json['genres'] != null) {
      json['genres'].forEach((v) {
        genres.add(v);
      });
    }
  }

  fromInstance(Map<String, dynamic> json) {
    externalUrls = json['external_urls'] != null
        ? ExternalUrls.fromJson(json['external_urls'])
        : null;
    href = json['href'] ?? href;
    id = json['id'] ?? id;
    name = json['name'] ?? name;
    type = json['type'] ?? type;
    uri = json['uri'] ?? uri;

    popularity = json['popularity'] ?? popularity;

    if (json['images'] != null) {
      json['images'].forEach((v) {
        images.add(Images.fromJson(v));
      });
    }

    if (json['genres'] != null) {
      json['genres'].forEach((v) {
        genres.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (externalUrls != null) {
      data['external_urls'] = externalUrls!.toJson();
    }
    data['href'] = href;
    data['id'] = id;
    data['name'] = name;
    data['type'] = type;
    data['uri'] = uri;
    return data;
  }
}
