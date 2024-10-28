import 'album_model.dart';
import 'artist_model.dart';
import 'external_ids_model.dart';
import 'external_urls_model.dart';
import 'images_model.dart';

class Track {
  Album? album;
  List<Artist>? artists;
  List<String>? availableMarkets;
  int? discNumber;
  int? durationMs;
  bool? episode;
  bool? explicit;
  ExternalIds? externalIds;
  ExternalUrls? externalUrls;
  String? href;
  String? id;
  bool? isLocal;
  String? name;
  int? popularity;
  String? previewUrl;
  bool? track;
  int? trackNumber;
  String? type;
  String? uri;
  List<Images>? images;
  String? allArtists;
  bool invalid = false;
  int previousInvalidTracks = 0;

  Track(
      {this.album,
      this.artists,
      this.availableMarkets,
      this.discNumber,
      this.durationMs,
      this.episode,
      this.explicit,
      this.externalIds,
      this.externalUrls,
      this.href,
      this.id,
      this.isLocal,
      this.name,
      this.popularity,
      this.previewUrl,
      this.track,
      this.trackNumber,
      this.type,
      this.uri,
      this.images,
      this.allArtists});

  Track.fromJson(Map<String, dynamic> json) {
    album = json['album'] != null ? Album.fromJson(json['album']) : null;
    if (json['artists'] != null) {
      artists = <Artist>[];
      json['artists'].forEach((v) {
        allArtists = '${allArtists ?? ''}${v['name']}, ';
        artists!.add(Artist.fromJson(v));
      });
      allArtists = allArtists!.substring(0, allArtists!.lastIndexOf(','));
    }

    if (json['available_markets'] != null) {
      availableMarkets = json['available_markets'].cast<String>();
    }

    discNumber = json['disc_number'];
    durationMs = json['duration_ms'];
    episode = json['episode'];
    explicit = json['explicit'];
    externalIds = json['external_ids'] != null
        ? ExternalIds.fromJson(json['external_ids'])
        : null;
    externalUrls = json['external_urls'] != null
        ? ExternalUrls.fromJson(json['external_urls'])
        : null;
    href = json['href'];
    id = json['id'];
    isLocal = json['is_local'];
    name = json['name'] ?? name;
    popularity = json['popularity'];
    previewUrl = json['preview_url'] ?? previewUrl;
    track = json['track'];
    trackNumber = json['track_number'];
    type = json['type'] ?? type;
    uri = json['uri'] ?? uri;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (album != null) {
      data['album'] = album!.toJson();
    }
    if (artists != null) {
      data['artists'] = artists!.map((v) => v.toJson()).toList();
    }

    if (availableMarkets != null) {
      data['available_markets'] = availableMarkets;
    }

    data['disc_number'] = discNumber;
    data['duration_ms'] = durationMs;
    data['episode'] = episode;
    data['explicit'] = explicit;
    if (externalIds != null) {
      data['external_ids'] = externalIds!.toJson();
    }
    if (externalUrls != null) {
      data['external_urls'] = externalUrls!.toJson();
    }
    data['href'] = href;
    data['id'] = id;
    data['is_local'] = isLocal;
    data['name'] = name;
    data['popularity'] = popularity;
    data['preview_url'] = previewUrl;
    data['track'] = track;
    data['track_number'] = trackNumber;
    data['type'] = type;
    data['uri'] = uri;
    return data;
  }
}
