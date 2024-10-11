import '../../models/primary models/user_playlists_model.dart';
import '../../models/secundary models/playlist_model.dart';
import '../auth/auth_controller.dart';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:retry/retry.dart';

class PlaylistService {
  Dio dio = Dio();
  var storage = const FlutterSecureStorage();
  PlaylistService() {
    dio.options.baseUrl = 'https://api.spotify.com/v1';
  }

  Future<UserPlaylists> getCurrentUserPlaylists(
      UserPlaylists userPlaylists, int limit, offset) async {
    try {
      var accessToken = await storage.read(key: 'accessToken');
      final response = await retry(() async {
        return await dio
            .get(
              '/me/playlists',
              queryParameters: {
                'limit': limit,
                'offset': offset,
              },
              options: Options(headers: {
                'Authorization': 'Bearer $accessToken',
                'Content-Type': 'application/json',
              }, contentType: Headers.jsonContentType),
            )
            .timeout(const Duration(seconds: 5));
      }, retryIf: (e) async {
        if (e is DioException && e.response!.statusMessage == 'Unauthorized') {
          await AuthController().syncSpotifyRemote();
          accessToken = await storage.read(key: 'accessToken');
          return true;
        }
        return false;
      });

      userPlaylists.fromJson(response.data);
      return userPlaylists;
    } on Exception {
      rethrow;
    }
  }

  Future<Playlist> getPlaylist(Playlist playlist) async {
    try {
      var accessToken = await storage.read(key: 'accessToken');

      final response = await retry(() async {
        return await dio.get(
          '/playlists/${playlist.id}',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
        );
      }, retryIf: (e) async {
        if (e is DioException && e.response!.statusMessage == 'Unauthorized') {
          await AuthController().syncSpotifyRemote();
          accessToken = await storage.read(key: 'accessToken');
          return true;
        }

        return false;
      });
      playlist.fromInstance(response.data);
      return playlist;
    } on Exception {
      rethrow;
    }
  }

  Future<Playlist> getPlaylistTracks(
      Playlist playlistTracks, int offset) async {
    try {
      var accessToken = await storage.read(key: 'accessToken');
      final response = await retry(() async {
        return await dio.get(
          '/playlists/${playlistTracks.id}/tracks',
          queryParameters: {
            'limit': 50,
            'offset': offset,
          },
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
        );
      }, retryIf: (e) async {
        if (e is DioException && e.response!.statusMessage == 'Unauthorized') {
          await AuthController().syncSpotifyRemote();
          accessToken = await storage.read(key: 'accessToken');
          return true;
        }

        return false;
      });
      playlistTracks.fromInstance(response.data);
      return playlistTracks;
    } on Exception {
      rethrow;
    }
  }
}
