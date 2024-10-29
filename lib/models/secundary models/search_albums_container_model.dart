import 'album_model.dart';

class SearchAlbumsContainer {
  String? href;
  List<Album>? items;
  int? limit;
  String? next;
  int? offset;
  String? previous;
  int? total;

  SearchAlbumsContainer(
      {this.href,
      this.items,
      this.limit,
      this.next,
      this.offset,
      this.previous,
      this.total});

  SearchAlbumsContainer.fromJson(Map<String, dynamic> json) {
    href = json['href'];
    if (json['items'] != null) {
      items = <Album>[];
      json['items'].forEach((v) {
        items!.add(Album.fromJson(v));
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
