import 'package:colab_helper_for_spotify/models/secundary models/external_urls_model.dart';
import 'package:colab_helper_for_spotify/models/secundary models/images_model.dart';
import 'package:colab_helper_for_spotify/models/secundary models/owner_model.dart';
import 'package:colab_helper_for_spotify/models/secundary%20models/track_model.dart';

class Playlist {
  bool? collaborative;
  String? description;
  ExternalUrls? externalUrls;
  String? href;
  String? id;
  List<Images>? images;
  String? name;
  Owner? owner;
  String? primaryColor;
  bool? public;
  String? snapshotId;
  List<Track>? tracks;
  String? type;
  String? uri;

  Playlist(
      {this.collaborative,
      this.description,
      this.externalUrls,
      this.href,
      this.id,
      this.images,
      this.name,
      this.owner,
      this.primaryColor,
      this.public,
      this.snapshotId,
      this.tracks,
      this.type,
      this.uri});

  Playlist.fromJson(Map<String, dynamic> json) {
    collaborative = json['collaborative'];
    description = json['description'];
    externalUrls = json['external_urls'] != null
        ? ExternalUrls.fromJson(json['external_urls'])
        : null;
    href = json['href'];
    id = json['id'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(Images.fromJson(v));
      });
    }
    name = json['name'];
    owner = json['owner'] != null ? Owner.fromJson(json['owner']) : null;
    primaryColor = json['primary_color'] ?? '';
    public = json['public'];
    snapshotId = json['snapshot_id'];

    if (json['items'] != null) {
      tracks = <Track>[];
      json['items'].forEach((v) {
        tracks!.add(Track.fromJson(v['track']));
      });
    }

    if (json['tracks'] != null) {
      tracks = <Track>[];
      tracks!.add(Track.fromJson(json['tracks']));
    }

    type = json['type'];
    uri = json['uri'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['collaborative'] = collaborative;
    data['description'] = description;
    if (externalUrls != null) {
      data['external_urls'] = externalUrls!.toJson();
    }
    data['href'] = href;
    data['id'] = id;
    if (images != null) {
      data['images'] = images!.map((v) => v.toJson()).toList();
    }
    data['name'] = name;
    if (owner != null) {
      data['owner'] = owner!.toJson();
    }
    data['primary_color'] = primaryColor;
    data['public'] = public;
    data['snapshot_id'] = snapshotId;

    if (tracks != null) {
      data['tracks'] = tracks!.map((v) => v.toJson()).toList();
    }

    data['type'] = type;
    data['uri'] = uri;
    return data;
  }
}
