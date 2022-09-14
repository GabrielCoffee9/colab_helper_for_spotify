import 'package:colab_helper_for_spotify/models/primary models/user_playlist_model.dart';
import 'package:retry/retry.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../features/auth/auth_controller.dart';

enum PlaylistState { idle, success, error, loading }

class PlaylistController extends ChangeNotifier {
  var state = PlaylistState.idle;

  UserPlaylistModel userPlaylists = UserPlaylistModel();
  Dio dio = Dio();
  var storage = const FlutterSecureStorage();

  PlaylistController() {
    dio.options.baseUrl = 'https://api.spotify.com/v1';
  }

  getPlaylistsCurrentUser() async {
    final response = await retry(() async {
      state = PlaylistState.loading;
      notifyListeners();

      var accessToken = await storage.read(key: 'accessToken');

      return await dio
          .get(
            '/me/playlists',
            queryParameters: {
              'limit': 3,
            },
            options: Options(headers: {
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json',
            }, contentType: Headers.jsonContentType),
          )
          .timeout(const Duration(seconds: 6));
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
      userPlaylists = UserPlaylistModel.fromJson(response.data);

      state = PlaylistState.success;
      notifyListeners();
    }
  }
}
