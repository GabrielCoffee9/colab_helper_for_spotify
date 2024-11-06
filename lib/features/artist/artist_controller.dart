import '../../models/secundary models/artist_model.dart';
import '../../models/secundary models/track_model.dart';
import 'artist_service.dart';

class ArtistController {
  Future<Artist> getArtist(String? artistId) async {
    try {
      if (artistId != null && artistId.isEmpty) {
        throw Exception('The given artistId is null or empty');
      }

      final response = await ArtistService().getArtist(artistId!);

      Artist artist = Artist.fromJson(response.data);

      return artist;
    } on Exception {
      rethrow;
    }
  }

  Future<List<Track>> getTopTracks(String? artistId, String? market) async {
    try {
      if (artistId != null && artistId.isEmpty) {
        throw Exception('The given artistId is null or empty');
      }

      if (market != null && market.isEmpty) {
        throw Exception('The given marketId is null or empty');
      }

      final response = await ArtistService().getTopTracks(artistId!, market!);

      final List<Track> topTracks = [];

      for (var track in response.data['tracks']) {
        topTracks.add(Track.fromJson(track));
      }

      return topTracks;
    } on Exception {
      rethrow;
    }
  }
}
