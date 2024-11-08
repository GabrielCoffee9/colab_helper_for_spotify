import 'artist_model.dart';
import 'copyright_model.dart';
import 'external_urls_model.dart';
import 'images_model.dart';
import 'track_model.dart';

class Album {
  String? albumType;
  List<Artist> artists = <Artist>[];
  List<Track> tracks = <Track>[];
  List<String>? availableMarkets;
  ExternalUrls? externalUrls;
  String? href;
  String? id;
  List<Images> images = <Images>[];
  List<Copyright> copyrights = <Copyright>[];
  String? name;
  String? releaseDate;
  String? releaseDatePrecision;
  int? totalTracks;
  String? type;
  String? uri;

  Album(
      {this.albumType,
      this.artists = const <Artist>[],
      this.tracks = const <Track>[],
      this.availableMarkets,
      this.externalUrls,
      this.href,
      this.id,
      this.images = const <Images>[],
      this.copyrights = const <Copyright>[],
      this.name,
      this.releaseDate,
      this.releaseDatePrecision,
      this.totalTracks,
      this.type,
      this.uri});

  Album.fromJson(Map<String, dynamic> json) {
    albumType = json['album_type'];

    if (json['artists'] != null) {
      json['artists'].forEach((v) {
        artists.add(Artist.fromJson(v));
      });
    }
    if (json['available_markets'] != null) {
      availableMarkets = json['available_markets'].cast<String>();
    }

    if (json['copyrights'] != null) {
      json['copyrights'].forEach((v) {
        copyrights.add(Copyright.fromJson(v));
      });
    }

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

    externalUrls = json['external_urls'] != null
        ? ExternalUrls.fromJson(json['external_urls'])
        : null;
    href = json['href'];
    id = json['id'];
    if (json['images'] != null) {
      json['images'].forEach((v) {
        images.add(Images.fromJson(v));
      });
    }
    name = json['name'];
    releaseDate = json['release_date'];
    releaseDatePrecision = json['release_date_precision'];
    totalTracks = json['total_tracks'];
    type = json['type'];
    uri = json['uri'];
  }

  fromInstance(Map<String, dynamic> json) {
    var previousInvalidTracks = 0;

    if (tracks.isNotEmpty) {
      previousInvalidTracks = tracks.last.previousInvalidTracks;
    }

    albumType = json['album_type'] ?? albumType;
    if (json['artists'] != null) {
      json['artists'].forEach((v) {
        artists.add(Artist.fromJson(v));
      });
    }

    if (json['available_markets'] != null) {
      availableMarkets = json['available_markets'].cast<String>();
    }
    externalUrls = json['external_urls'] != null
        ? ExternalUrls.fromJson(json['external_urls'])
        : null;

    if (json['copyrights'] != null) {
      json['copyrights'].forEach((v) {
        copyrights.add(Copyright.fromJson(v));
      });
    }

    if (json['items'] != null) {
      json['items'].forEach((v) {
        var newTrack = Track.fromJson(v);
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
    href = json['href'] ?? href;
    id = json['id'] ?? id;
    if (json['images'] != null) {
      json['images'].forEach((v) {
        images.add(Images.fromJson(v));
      });
    }
    name = json['name'] ?? name;
    releaseDate = json['release_date'] ?? releaseDate;
    releaseDatePrecision =
        json['release_date_precision'] ?? releaseDatePrecision;
    totalTracks = json['total_tracks'] ?? totalTracks;
    type = json['type'] ?? type;
    uri = json['uri'] ?? uri;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['album_type'] = albumType;
    data['artists'] = artists.map((v) => v.toJson()).toList();
    data['available_markets'] = availableMarkets;
    if (externalUrls != null) {
      data['external_urls'] = externalUrls!.toJson();
    }
    data['href'] = href;
    data['id'] = id;
    data['images'] = images.map((v) => v.toJson()).toList();
    data['name'] = name;
    data['release_date'] = releaseDate;
    data['release_date_precision'] = releaseDatePrecision;
    data['total_tracks'] = totalTracks;
    data['type'] = type;
    data['uri'] = uri;
    return data;
  }
}
