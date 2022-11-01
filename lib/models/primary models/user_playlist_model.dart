import 'package:colab_helper_for_spotify/models/secundary%20models/playlist_items_model.dart';

class UserPlaylists {
  String? href;
  List<PlaylistItems>? items;
  int? limit;
  String? next;
  int? offset;
  String? previous;
  int? total;

  UserPlaylists(
      {this.href,
      this.items,
      this.limit,
      this.next,
      this.offset,
      this.previous,
      this.total});

  UserPlaylists.fromJson(Map<String, dynamic> json) {
    href = json['href'];

    if (json['items'] != null) {
      items = <PlaylistItems>[];
      json['items'].forEach((v) {
        items!.add(PlaylistItems.fromJson(v));
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
