import 'addedby_model.dart';
import 'track_model.dart';
import 'video_thumbnail_model.dart';

class TrackItems {
  String? addedAt;
  AddedBy? addedBy;
  bool? isLocal;
  String? primaryColor;
  Track? track;
  VideoThumbnail? videoThumbnail;

  TrackItems(
      {this.addedAt,
      this.addedBy,
      this.isLocal,
      this.primaryColor,
      this.track,
      this.videoThumbnail});

  TrackItems.fromJson(Map<String, dynamic> json) {
    addedAt = json['added_at'];
    addedBy =
        json['added_by'] != null ? AddedBy.fromJson(json['added_by']) : null;
    isLocal = json['is_local'];
    primaryColor = json['primary_color'];
    track = json['track'] != null ? Track.fromJson(json['track']) : null;
    videoThumbnail = json['video_thumbnail'] != null
        ? VideoThumbnail.fromJson(json['video_thumbnail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['added_at'] = addedAt;
    if (addedBy != null) {
      data['added_by'] = addedBy!.toJson();
    }
    data['is_local'] = isLocal;
    data['primary_color'] = primaryColor;
    if (track != null) {
      data['track'] = track!.toJson();
    }
    if (videoThumbnail != null) {
      data['video_thumbnail'] = videoThumbnail!.toJson();
    }
    return data;
  }
}
