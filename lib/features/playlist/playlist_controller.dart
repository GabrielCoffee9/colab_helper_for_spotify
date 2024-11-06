import '../../models/primary models/search_items.dart';
import '../../models/primary models/user_playlists_model.dart';
import '../../models/secundary models/playlist_model.dart';
import 'playlist_service.dart';

import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum PlaylistState { idle, success, error, loading }

class PlaylistController {
  PlaylistController();

  var state = ValueNotifier(PlaylistState.idle);
  var storage = const FlutterSecureStorage();

  String? lastError;

  Future<UserPlaylists> getCurrentUserPlaylists({
    int limit = 25,
    required int offset,
    UserPlaylists? currentUserPlaylists,
  }) async {
    try {
      state.value = PlaylistState.loading;

      if (offset > 0 && currentUserPlaylists == null) {
        throw Exception('The given currentUserPlaylists is null');
      }

      final response =
          await PlaylistService().getCurrentUserPlaylists(limit, offset);

      if (offset == 0) {
        state.value = PlaylistState.idle;
        return UserPlaylists.fromJson(response.data);
      } else {
        currentUserPlaylists!.fromInstance(response.data);
        state.value = PlaylistState.idle;
        return currentUserPlaylists;
      }
    } on Exception catch (e) {
      lastError = e.toString();
      state.value = PlaylistState.error;
      return UserPlaylists();
    }
  }

  Future<Playlist> getPlaylistTracks(
    Playlist playlist,
    String? market,
    int offset,
  ) async {
    try {
      if (market == null) {
        throw Exception('The given market is null');
      }

      state.value = PlaylistState.loading;

      final response = await PlaylistService()
          .getPlaylistTracks(playlist.id!, market, offset);

      playlist.fromInstance(response.data);
      state.value = PlaylistState.idle;
      return playlist;
    } on Exception catch (e) {
      lastError = e.toString();
      state.value = PlaylistState.error;
      return Playlist();
    }
  }

  Future<SearchItems> searchPlaylists(
    String query,
    String market,
    int offset,
  ) async {
    final response =
        await PlaylistService().searchPlaylists(query, market, offset);

    return SearchItems.fromJson(response.data);
  }

  Future<bool> checkIfCurrentUserFollowsPlaylist(String? playlistId) async {
    try {
      if (playlistId == null || playlistId.isEmpty) {
        throw Exception('The given playlistId is null or empty');
      }

      final response =
          await PlaylistService().checkIfCurrentUserFollowsPlaylist(playlistId);

      return response.data[0];
    } on Exception catch (e) {
      lastError = e.toString();
      state.value = PlaylistState.error;
      return false;
    }
  }
}
