import '../secundary models/playlist_model.dart';

class UserColabPlaylist {
  String? href;
  List<Playlist> items = <Playlist>[];
  int? limit;
  String? next;
  int? offset;
  String? previous;
  int? total;

  UserColabPlaylist(
      {this.href,
      this.items = const <Playlist>[],
      this.limit,
      this.next,
      this.offset,
      this.previous,
      this.total});

  UserColabPlaylist.fromJson(Map<String, dynamic> json) {
    href = json['href'];
    if (json['items'] != null) {
      json['items'].forEach((v) {
        if (v != null && v['collaborative'] == true) {
          items.add(Playlist.fromJson(v));
        }
      });
    }
    limit = json['limit'];
    next = json['next'];
    offset = json['offset'];
    previous = json['previous'];
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
