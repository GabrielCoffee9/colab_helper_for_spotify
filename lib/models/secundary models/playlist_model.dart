import 'external_urls_model.dart';
import 'image_model.dart';
import 'owner_model.dart';
import 'track_model.dart';

import 'package:html_unescape/html_unescape_small.dart';

class Playlist {
  bool? collaborative;
  String? description;
  ExternalUrls? externalUrls;
  String? href;
  String? id;
  List<Image>? images = <Image>[];
  String? name;
  Owner? owner;
  String? primaryColor;
  bool? public;
  String? snapshotId;
  List<Track> tracks = <Track>[];
  bool hasMoreToLoad = true;
  String? type;
  String? uri;
  bool haveImage = false;
  int total = 0;
  bool isUserSavedTracksPlaylist = false;

  Playlist({
    this.collaborative,
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
    this.tracks = const <Track>[],
    this.type,
    this.uri,
    this.isUserSavedTracksPlaylist = false,
    this.total = 0,
  });

  Playlist.fromJson(Map<String, dynamic> json) {
    collaborative = json['collaborative'] ?? collaborative;

    description = json['description'] != null
        ? HtmlUnescape().convert(json['description'])
        : description;

    externalUrls = json['external_urls'] != null
        ? ExternalUrls.fromJson(json['external_urls'])
        : null;
    href = json['href'];
    total = json['total'] ?? 0;
    id = json['id'] ?? id;
    if (json['images'] != null) {
      json['images'].forEach((v) {
        images!.add(Image.fromJson(v));
      });
    }

    if (images != null && images!.isNotEmpty) {
      haveImage = true;
    }

    name = json['name'] ?? name;

    owner = json['owner'] != null ? Owner.fromJson(json['owner']) : owner;

    primaryColor = json['primary_color'] ?? '';
    public = json['public'];
    snapshotId = json['snapshot_id'];

    if (json['items'] != null) {
      json['items'].forEach((v) {
        if (v['track']['id'] != null) {
          tracks.add(Track.fromJson(v['track']));
        }
      });
    }

    if (json['tracks'] != null) {
      if (json['tracks']['id'] != null) {
        tracks.add(Track.fromJson(json['tracks']));
      }
    }

    if (json['next'] == null) {
      hasMoreToLoad = false;
    }

    type = json['type'] ?? type;
    uri = json['uri'] ?? uri;
  }

  fromInstance(Map<String, dynamic> json) {
    var previousInvalidTracks = 0;

    if (tracks.isNotEmpty) {
      previousInvalidTracks = tracks.last.previousInvalidTracks;
    }

    hasMoreToLoad = true;
    collaborative = json['collaborative'] ?? collaborative;
    description = json['description'] ?? description;
    externalUrls = json['external_urls'] != null
        ? ExternalUrls.fromJson(json['external_urls'])
        : null;
    href = json['href'];
    total = json['total'] ?? 0;
    id = json['id'] ?? id;
    if (json['images'] != null) {
      json['images'].forEach((v) {
        images!.add(Image.fromJson(v));
      });
    }

    if (images != null && images!.isNotEmpty) {
      haveImage = true;
    }

    name = json['name'] ?? name;
    owner = json['owner'] != null ? Owner.fromJson(json['owner']) : owner;
    primaryColor = json['primary_color'] ?? '';
    public = json['public'];
    snapshotId = json['snapshot_id'] ?? snapshotId;

    if (json['items'] != null) {
      json['items'].forEach((v) {
        var newTrack = Track.fromJson(v['track']);
        if ((newTrack.name?.isEmpty ?? true) && (newTrack.durationMs == 0)) {
          newTrack.invalid = true;
          previousInvalidTracks++;
        }

        if (previousInvalidTracks > 0) {
          newTrack.previousInvalidTracks = previousInvalidTracks;
        }
        tracks.add(newTrack);
      });
    }

    if (json['tracks'] != null) {
      var newTrack = Track.fromJson(json['tracks']);
      if ((newTrack.name?.isEmpty ?? true) && (newTrack.durationMs == 0)) {
        newTrack.invalid = true;
        previousInvalidTracks++;
      }
      if (previousInvalidTracks > 0) {
        newTrack.previousInvalidTracks = previousInvalidTracks;
      }
      tracks.add(newTrack);
    }

    if (json['next'] == null) {
      hasMoreToLoad = false;
    }

    type = json['type'] ?? type;
    uri = json['uri'] ?? uri;
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

    data['tracks'] = tracks.map((v) => v.toJson()).toList();

    data['type'] = type;
    data['uri'] = uri;
    return data;
  }
}
