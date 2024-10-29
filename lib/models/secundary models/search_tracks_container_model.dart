import 'track_model.dart';

class SearchTracksContainer {
  String? href;
  List<Track>? items;
  int? limit;
  String? next;
  int? offset;
  String? previous;
  int? total;

  SearchTracksContainer(
      {this.href,
      this.items,
      this.limit,
      this.next,
      this.offset,
      this.previous,
      this.total});

  SearchTracksContainer.fromJson(Map<String, dynamic> json) {
    href = json['href'];
    if (json['items'] != null) {
      items = <Track>[];
      json['items'].forEach((v) {
        items!.add(Track.fromJson(v));
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