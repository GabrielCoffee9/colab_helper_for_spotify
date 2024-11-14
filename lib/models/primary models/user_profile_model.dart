import '../secundary models/explicit_content_model.dart';
import '../secundary models/external_urls_model.dart';
import '../secundary models/followers_model.dart';
import '../secundary models/image_model.dart';

import 'package:flutter/material.dart' hide Image;

class UserProfile extends ChangeNotifier {
  static final UserProfile _instance = UserProfile._();
  static UserProfile get instance => _instance;

  UserProfile._();

  String? country;
  String? displayName;
  String? email;
  ExplicitContent? explicitContent;
  ExternalUrls? externalUrls;
  Followers? followers;
  String? href;
  String? id;
  List<Image> images = <Image>[];
  String? product;
  bool isFreeUser = true;
  String? type;
  String? uri;

  UserProfile(
      {this.country,
      this.displayName,
      this.email,
      this.explicitContent,
      this.externalUrls,
      this.followers,
      this.href,
      this.id,
      this.images = const <Image>[],
      this.product,
      this.type,
      this.uri});

  fromJson(Map<String, dynamic> json) {
    country = json['country'];
    displayName = json['display_name'];
    email = json['email'];
    explicitContent = json['explicit_content'] != null
        ? ExplicitContent.fromJson(json['explicit_content'])
        : null;
    externalUrls = json['external_urls'] != null
        ? ExternalUrls.fromJson(json['external_urls'])
        : null;
    followers = json['followers'] != null
        ? Followers.fromJson(json['followers'])
        : null;
    href = json['href'];
    id = json['id'];
    if (json['images'] != null) {
      json['images'].forEach((v) {
        images.add(Image.fromJson(v));
      });
    }
    product = json['product'];

    if (product != null && product == 'premium') {
      isFreeUser = false;
    }

    type = json['type'];
    uri = json['uri'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['country'] = country;
    data['display_name'] = displayName;
    data['email'] = email;
    if (explicitContent != null) {
      data['explicit_content'] = explicitContent!.toJson();
    }
    if (externalUrls != null) {
      data['external_urls'] = externalUrls!.toJson();
    }
    if (followers != null) {
      data['followers'] = followers!.toJson();
    }
    data['href'] = href;
    data['id'] = id;
    data['images'] = images.map((v) => v.toJson()).toList();
    data['product'] = product;
    data['type'] = type;
    data['uri'] = uri;
    return data;
  }
}
