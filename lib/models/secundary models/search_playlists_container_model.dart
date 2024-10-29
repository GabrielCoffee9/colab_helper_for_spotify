import 'playlist_model.dart';

class SearchPlaylistContainer {
  String? href;
  List<Playlist>? items;
  int? limit;
  String? next;
  int? offset;
  String? previous;
  int? total;

  SearchPlaylistContainer(
      {this.href,
      this.items,
      this.limit,
      this.next,
      this.offset,
      this.previous,
      this.total});

  SearchPlaylistContainer.fromJson(Map<String, dynamic> json) {
    href = json['href'];
    if (json['items'] != null) {
      items = <Playlist>[];
      json['items'].forEach((v) {
        items!.add(Playlist.fromJson(v));
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
    data['items'] = items;
    data['limit'] = limit;
    data['next'] = next;
    data['offset'] = offset;
    data['previous'] = previous;
    data['total'] = total;
    return data;
  }
}
