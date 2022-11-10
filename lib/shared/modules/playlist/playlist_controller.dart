// import 'package:colab_helper_for_spotify/models/primary%20models/user_colab_playlist_model.dart';
import 'package:colab_helper_for_spotify/models/primary%20models/user_playlists_model.dart';
import 'package:colab_helper_for_spotify/shared/modules/playlist/playlist_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum PlaylistState { idle, success, error, loading }

class PlaylistController extends ChangeNotifier {
  var state = PlaylistState.idle;

  Dio dio = Dio();
  var storage = const FlutterSecureStorage();

  String selectedPlaylistid = '';

  PlaylistController();

  setSelectedPlaylistId(String id) {
    selectedPlaylistid = id;
  }

  Future<UserPlaylists> getCurrentUserPlaylists() async {
    return await PlaylistService().getCurrentUserPlaylists();
  }
}
