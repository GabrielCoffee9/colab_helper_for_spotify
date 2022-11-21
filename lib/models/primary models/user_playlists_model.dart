import 'package:colab_helper_for_spotify/models/secundary%20models/playlist_model.dart';

class UserPlaylists {
  String? href;
  List<Playlist>? playlists;
  int? limit;
  String? next;
  int? offset;
  String? previous;
  int? total;

  static final UserPlaylists _instance = UserPlaylists._();
  static UserPlaylists get instance => _instance;

  UserPlaylists._();

  UserPlaylists(
      {this.href,
      this.playlists,
      this.limit,
      this.next,
      this.offset,
      this.previous,
      this.total});

  fromJson(Map<String, dynamic> json) {
    href = json['href'];

    if (json['items'] != null) {
      playlists = <Playlist>[];
      json['items'].forEach((v) {
        playlists!.add(Playlist.fromJson(v));
      });
    }
    limit = json['limit'];
    next = json['next'] ?? '';
    offset = json['offset'];
    previous = json['previous'] ?? '';
    total = json['total'];
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
