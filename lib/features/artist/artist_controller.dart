import '../../models/secundary models/album_model.dart';
import '../../models/secundary models/artist_model.dart';
import '../../models/secundary models/track_model.dart';
import 'artist_service.dart';

class ArtistController {
  Future<Artist> getArtist(String? artistId, String? market) async {
    try {
      if (artistId == null) {
        throw Exception('The given artistId is null.');
      }

      if (market == null) {
        throw Exception('The given marketId is null.');
      }

      final response = await ArtistService().getArtist(artistId);

      Artist artist = Artist.fromJson(response.data);

      final toptracks = await getTopTracks(artistId, market);

      artist.topTracks = toptracks;

      artist = await getAlbums(artist, market);

      return artist;
    } on Exception {
      rethrow;
    }
  }

  Future<List<Track>> getTopTracks(String? artistId, String? market) async {
    try {
      if (artistId == null) {
        throw Exception('The given artistId is null');
      }

      if (market == null) {
        throw Exception('The given marketId is null');
      }

      final response = await ArtistService().getTopTracks(artistId, market);

      final List<Track> topTracks = [];

      for (var track in response.data['tracks']) {
        topTracks.add(Track.fromJson(track));
      }

      return topTracks;
    } on Exception {
      rethrow;
    }
  }

  Future<Artist> getAlbums(
    Artist artist,
    String? market, {
    int offset = 0,
  }) async {
    try {
      if (artist.id == null) {
        throw Exception('The given artistId is null');
      }

      if (market == null) {
        throw Exception('The given marketId is null');
      }

      final response =
          await ArtistService().getAlbums(artist.id!, market, offset);

      for (var album in response.data['items']) {
        artist.albums.add(Album.fromJson(album));
      }

      artist.albums.sort((a, b) {
        DateTime parseDate(String? date) {
          if (date == null) {
            return DateTime(1900, 1, 1);
          }

          if (date.length == 4) {
            return DateTime.parse('$date-01-01');
          }
          return DateTime.parse(date);
        }

        DateTime dateA = parseDate(a.releaseDate);
        DateTime dateB = parseDate(b.releaseDate);
        return dateB.compareTo(dateA);
      });

      artist.totalAlbumsCount = response.data['total'];

      return artist;
    } on Exception {
      rethrow;
    }
  }

  Future<bool> chechIfUserFollowsArtist(String? artistId) async {
    try {
      if (artistId == null) {
        throw Exception('The given artistId is null.');
      }

      final response = await ArtistService().chechIfUserFollowsArtist(artistId);

      return response.data[0];
    } on Exception {
      rethrow;
    }
  }

  Future<bool> followArtist(String? artistId) async {
    try {
      if (artistId == null) {
        throw Exception('The given artistId is null.');
      }

      final response = await ArtistService().followArtist(artistId);

      if (response.statusCode == 204) {
        return true;
      } else {
        return false;
      }
    } on Exception {
      rethrow;
    }
  }

  Future<bool> unfollowArtist(String? artistId) async {
    try {
      if (artistId == null) {
        throw Exception('The given artistId is null.');
      }

      final response = await ArtistService().unfollowArtist(artistId);

      if (response.statusCode == 204) {
        return true;
      } else {
        return false;
      }
    } on Exception {
      rethrow;
    }
  }
}
