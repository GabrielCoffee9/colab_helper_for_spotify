import 'package:colab_helper_for_spotify/models/secundary models/playlist_items.dart';

class UserPlaylistModel {
  String? href;
  List<PlaylistItems>? items;
  int? limit;
  String? next;
  int? offset;
  String? previous;
  int? total;

  UserPlaylistModel(
      {this.href,
      this.limit,
      this.next,
      this.offset,
      this.previous,
      this.total});

  UserPlaylistModel.fromJson(Map<String, dynamic> json) {
    href = json['href'];
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
