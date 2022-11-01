import 'package:colab_helper_for_spotify/models/secundary%20models/track_items_model.dart';

class TrackList {
  String? href;
  List<TrackItems>? items;
  int? limit;
  String? next;
  int? offset;
  String? previous;
  int? total;

  TrackList(
      {this.href,
      this.items,
      this.limit,
      this.next,
      this.offset,
      this.previous,
      this.total});

  TrackList.fromJson(Map<String, dynamic> json) {
    href = json['href'];
    if (json['items'] != null) {
      items = <TrackItems>[];
      json['items'].forEach((v) {
        items!.add(TrackItems.fromJson(v));
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
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    data['limit'] = limit;
    data['next'] = next;
    data['offset'] = offset;
    data['previous'] = previous;
    data['total'] = total;
    return data;
  }
}
