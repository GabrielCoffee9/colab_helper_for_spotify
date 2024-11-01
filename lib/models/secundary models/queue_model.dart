import 'track_model.dart';

class Queue {
  Track? currentlyPlaying;
  List<Track> items = <Track>[];

  Queue({
    this.currentlyPlaying,
    this.items = const <Track>[],
  });

  Queue.fromJson(Map<String, dynamic> json) {
    currentlyPlaying = json['currently_playing'] != null
        ? Track.fromJson(json['currently_playing'])
        : null;
    if (json['queue'] != null) {
      json['queue'].forEach((v) {
        items.add(Track.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (currentlyPlaying != null) {
      data['currently_playing'] = currentlyPlaying!.toJson();
    }
    data['queue'] = items.map((v) => v.toJson()).toList();
    return data;
  }
}
