import '../secundary models/playlist_model.dart';

class UserPlaylists {
  String? href;
  List<Playlist> playlists = <Playlist>[];
  int? limit;
  String? next;
  int? offset;
  String? previous;
  int? total;

  UserPlaylists(
      {this.href,
      this.playlists = const <Playlist>[],
      this.limit,
      this.next,
      this.offset,
      this.previous,
      this.total});

  UserPlaylists.fromJson(Map<String, dynamic> json) {
    href = json['href'];
    if (json['items'] != null) {
      json['items'].forEach((v) {
        playlists.add(Playlist.fromJson(v));
      });
    }
    limit = json['limit'];
    next = json['next'] ?? '';
    offset = json['offset'];
    previous = json['previous'] ?? '';
    total = json['total'];
  }

  fromInstance(Map<String, dynamic> json) {
    href = json['href'] ?? href;
    if (json['items'] != null) {
      json['items'].forEach((v) {
        playlists.add(Playlist.fromJson(v));
      });
    }
    limit = json['limit'] ?? limit;
    next = json['next'] ?? next;
    offset = json['offset'] ?? offset;
    previous = json['previous'] ?? previous;
    total = json['total'] ?? total;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['href'] = href;
    data['limit'] = limit;
    data['next'] = next;
    data['offset'] = offset;
    data['previous'] = previous;
    data['total'] = total;
    return data;
  }
}
