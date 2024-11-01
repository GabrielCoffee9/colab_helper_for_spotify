import 'artist_model.dart';

class SearchArtistsContainer {
  String? href;
  List<Artist>? items = <Artist>[];
  int? limit;
  String? next;
  int? offset;
  String? previous;
  int? total;

  SearchArtistsContainer(
      {this.href,
      this.items,
      this.limit,
      this.next,
      this.offset,
      this.previous,
      this.total});

  SearchArtistsContainer.fromJson(Map<String, dynamic> json) {
    href = json['href'];
    if (json['items'] != null) {
      json['items'].forEach((v) {
        items!.add(Artist.fromJson(v));
      });
    }
    limit = json['limit'];
    next = json['next'];
    offset = json['offset'];
    previous = json['previous'];
    total = json['total'];
  }

  fromInstance(Map<String, dynamic> json) {
    href = json['href'] ?? href;
    if (json['items'] != null) {
      json['items'].forEach((v) {
        items!.add(Artist.fromJson(v));
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
    data['items'] = items;
    data['limit'] = limit;
    data['next'] = next;
    data['offset'] = offset;
    data['previous'] = previous;
    data['total'] = total;
    return data;
  }
}
