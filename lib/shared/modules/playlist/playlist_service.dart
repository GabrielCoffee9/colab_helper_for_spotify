import 'package:colab_helper_for_spotify/features/auth/auth_controller.dart';
import 'package:colab_helper_for_spotify/models/primary%20models/user_playlists_model.dart';
import 'package:colab_helper_for_spotify/models/secundary%20models/playlist_model.dart';
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
    final response = await retry(() async {
      var accessToken = await storage.read(key: 'accessToken');

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
      if (e is DioError && e.response!.statusMessage == 'Unauthorized') {
        return await AuthController().verifySync();
      }

      return false;
    });

    userPlaylists.fromJson(response.data);

    return userPlaylists;
  }

  Future<Playlist> getPlaylist(Playlist playlist) async {
    final response = await retry(() async {
      var accessToken = await storage.read(key: 'accessToken');

      return await dio.get(
        '/playlists/${playlist.id}',
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        }, contentType: Headers.jsonContentType),
      );
    }, retryIf: (e) async {
      if (e is DioError && e.response!.statusMessage == 'Unauthorized') {
        return await AuthController().verifySync();
      }

      return false;
    });
    playlist.fromInstance(response.data);
    return playlist;
  }

  Future<Playlist> getPlaylistTracks(
      Playlist playlistTracks, int offset) async {
    final response = await retry(() async {
      var accessToken = await storage.read(key: 'accessToken');

      return await dio.get(
        '/playlists/${playlistTracks.id}/tracks',
        queryParameters: {
          'limit': 50,
          'offset': offset,
        },
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        }, contentType: Headers.jsonContentType),
      );
    }, retryIf: (e) async {
      if (e is DioError && e.response!.statusMessage == 'Unauthorized') {
        return await AuthController().verifySync();
      }

      return false;
    });
    playlistTracks.fromInstance(response.data);
    return playlistTracks;
  }

  playSong(String? contextUri) async {
    if (contextUri == null) {
      return;
    }
    await retry(() async {
      var accessToken = await storage.read(key: 'accessToken');

      return await dio
          .put(
            '/me/player/play',
            data: <String, dynamic>{
              'uris': [contextUri],
              'position_ms': 0,
            },
            options: Options(
              headers: {
                'Authorization': 'Bearer $accessToken',
                'Content-Type': 'application/json',
              },
              contentType: Headers.jsonContentType,
            ),
          )
          .timeout(const Duration(seconds: 5));
    }, retryIf: (e) async {
      if (e is DioError && e.response!.statusMessage == 'Unauthorized') {
        return await AuthController().verifySync();
      }

      return false;
    });
  }
}
