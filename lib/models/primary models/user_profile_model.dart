import 'package:colab_helper_for_spotify/models/secundary models/explicit_content_model.dart';
import 'package:colab_helper_for_spotify/models/secundary models/external_urls_model.dart';
import 'package:colab_helper_for_spotify/models/secundary models/followers_model.dart';
import 'package:colab_helper_for_spotify/models/secundary models/images_model.dart';
import 'package:flutter/material.dart';

class UserProfileModel extends ChangeNotifier {
  String? country;
  String? displayName;
  String? email;
  ExplicitContentModel? explicitContent;
  ExternalUrlsModel? externalUrls;
  FollowersModel? followers;
  String? href;
  String? id;
  List<ImagesModel>? images;
  String? product;
  String? type;
  String? uri;

  UserProfileModel(
      {this.country,
      this.displayName,
      this.email,
      this.explicitContent,
      this.externalUrls,
      this.followers,
      this.href,
      this.id,
      this.images,
      this.product,
      this.type,
      this.uri});

  UserProfileModel.fromJson(Map<String, dynamic> json) {
    country = json['country'];
    displayName = json['display_name'];
    email = json['email'];
    explicitContent = json['explicit_content'] != null
        ? ExplicitContentModel.fromJson(json['explicit_content'])
        : null;
    externalUrls = json['external_urls'] != null
        ? ExternalUrlsModel.fromJson(json['external_urls'])
        : null;
    followers = json['followers'] != null
        ? FollowersModel.fromJson(json['followers'])
        : null;
    href = json['href'];
    id = json['id'];
    if (json['images'] != null) {
      images = <ImagesModel>[];
      json['images'].forEach((v) {
        images!.add(ImagesModel.fromJson(v));
      });
    }
    product = json['product'];
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
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    data['product'] = product;
    data['type'] = type;
    data['uri'] = uri;
    return data;
  }
}
