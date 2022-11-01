import 'package:colab_helper_for_spotify/features/auth/auth_controller.dart';
import 'package:colab_helper_for_spotify/models/primary models/user_playlist_model.dart';
// import 'package:colab_helper_for_spotify/models/primary%20models/user_colab_playlist_model.dart';
import 'package:colab_helper_for_spotify/models/secundary%20models/playlist_items_model.dart';
import 'package:retry/retry.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum PlaylistState { idle, success, error, loading }

class PlaylistController extends ChangeNotifier {
  var state = PlaylistState.idle;

  Dio dio = Dio();
  var storage = const FlutterSecureStorage();

  PlaylistController() {
    dio.options.baseUrl = 'https://api.spotify.com/v1';
  }

  Future<UserPlaylists> getCurrentUserPlaylists() async {
    final response = await retry(() async {
      state = PlaylistState.loading;

      var accessToken = await storage.read(key: 'accessToken');

      return await dio
          .get(
            '/me/playlists',
            queryParameters: {
              'limit': 50,
            },
            options: Options(headers: {
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json',
            }, contentType: Headers.jsonContentType),
          )
          .timeout(const Duration(seconds: 5));
    }, retryIf: (e) async {
      if (e is DioError && e.response!.statusMessage == 'Unauthorized') {
        await AuthController().getToken();
        return true;
      }

      state = PlaylistState.error;
      notifyListeners();
      return false;
    });

    if (state != PlaylistState.error) {
      UserPlaylists userPlaylists = UserPlaylists.fromJson(response.data);

      state = PlaylistState.success;
      notifyListeners();

      return userPlaylists;
    }

    return UserPlaylists();
  }

  // Future<UserColabPlaylist> getCurrentUserColabPlaylists(String userid) async {
  //   final response = await retry(() async {
  //     state = PlaylistState.loading;

  //     var accessToken = await storage.read(key: 'accessToken');

  //     return await dio
  //         .get(
  //           '/users/$userid/playlists',
  //           queryParameters: {
  //             'limit': 50,
  //           },
  //           options: Options(headers: {
  //             'Authorization': 'Bearer $accessToken',
  //             'Content-Type': 'application/json',
  //           }, contentType: Headers.jsonContentType),
  //         )
  //         .timeout(const Duration(seconds: 5));
  //   }, retryIf: (e) async {
  //     if (e is DioError && e.response!.statusMessage == 'Unauthorized') {
  //       await AuthController().getToken();
  //       return true;
  //     }

  //     state = PlaylistState.error;
  //     notifyListeners();
  //     return false;
  //   });

  //   if (state != PlaylistState.error) {
  //     userColabPlaylists = UserColabPlaylist.fromJson(response.data);

  //     state = PlaylistState.success;
  //     notifyListeners();

  //     return userColabPlaylists;
  //   }

  //   return UserColabPlaylist();
  // }

  Future<UserPlaylists> getPlaylistItems(
      PlaylistItems playlist, int offset) async {
    final response = await retry(() async {
      state = PlaylistState.loading;

      var accessToken = await storage.read(key: 'accessToken');

      return await dio
          .get(
            '/playlists/${playlist.id}/tracks',
            queryParameters: {
              'limit': 50,
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
        await AuthController().getToken();
        return true;
      }

      state = PlaylistState.error;
      notifyListeners();
      return false;
    });

    if (state != PlaylistState.error) {
      UserPlaylists userPlaylists = UserPlaylists.fromJson(response.data);

      state = PlaylistState.success;
      notifyListeners();

      return userPlaylists;
    }

    return UserPlaylists();
  }
}
