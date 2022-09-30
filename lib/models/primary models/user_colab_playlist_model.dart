import 'package:colab_helper_for_spotify/models/secundary%20models/playlist_items_model.dart';

class UserColabPlaylistModel {
  String? href;
  List<PlaylistItemsModel>? items;
  int? limit;
  String? next;
  int? offset;
  String? previous;
  int? total;

  UserColabPlaylistModel(
      {this.href,
      this.items,
      this.limit,
      this.next,
      this.offset,
      this.previous,
      this.total});

  UserColabPlaylistModel.fromJson(Map<String, dynamic> json) {
    href = json['href'];
    if (json['items'] != null) {
      items = <PlaylistItemsModel>[];
      json['items'].forEach((v) {
        if (v['collaborative'] == true) {
          items!.add(PlaylistItemsModel.fromJson(v));
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