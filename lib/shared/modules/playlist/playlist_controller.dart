import 'package:colab_helper_for_spotify/models/primary%20models/user_playlists_model.dart';
import 'package:colab_helper_for_spotify/models/secundary%20models/playlist_model.dart';
import 'package:colab_helper_for_spotify/shared/modules/playlist/playlist_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum PlaylistState { idle, success, error, loading }

class PlaylistController extends ChangeNotifier {
  PlaylistController();
  Dio dio = Dio();

  var state = ValueNotifier(PlaylistState.idle);
  var storage = const FlutterSecureStorage();

  final UserPlaylists _userPlaylists = UserPlaylists.instance;

  void clearPlaylistsMemory() {
    if (_userPlaylists.playlists != null &&
        _userPlaylists.playlists!.isNotEmpty) {
      _userPlaylists.playlists!.clear();
    }
  }

  void clearTracksMemory(Playlist targetPlaylist) {
    if (targetPlaylist.tracks != null && targetPlaylist.tracks!.isNotEmpty) {
      targetPlaylist.tracks!.clear();
    }
  }

  Future<UserPlaylists> getCurrentUserPlaylists(
      {required int limit, required int offset}) async {
    if (offset == 0) {
      clearPlaylistsMemory();
    }

    return await PlaylistService()
        .getCurrentUserPlaylists(_userPlaylists, limit, offset);
  }

  Future<Playlist> getPlaylistTracks(
      Playlist playlistTracks, int offset) async {
    state.value = PlaylistState.loading;
    if (offset == 0) {
      clearTracksMemory(playlistTracks);
    }

    return await PlaylistService()
        .getPlaylistTracks(playlistTracks, offset)
        .whenComplete(() => state.value = PlaylistState.idle);
  }
}
