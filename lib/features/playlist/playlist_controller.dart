import '../../models/primary models/search_items.dart';
import '../../models/primary models/user_playlists_model.dart';
import '../../models/primary models/user_profile_model.dart';
import '../../models/secundary models/image_model.dart';
import '../../models/secundary models/owner_model.dart';
import '../../models/secundary models/playlist_model.dart';
import '../../models/secundary models/track_model.dart';
import 'playlist_service.dart';

import 'package:flutter/widgets.dart' hide Image;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'dart:typed_data';

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

        final userSavedPlaylistTracks = await PlaylistService()
            .getSavedTracks(UserProfile.instance.country ?? 'us', offset);

        List<Track> tracks = [];

        if (userSavedPlaylistTracks.data['items'] != null) {
          userSavedPlaylistTracks.data['items'].forEach((v) {
            if (v['track']['id'] != null) {
              tracks.add(Track.fromJson(v['track']));
            }
          });
        }

        Playlist savedPlaylistTracks = Playlist(
          uri: 'spotify:user:${UserProfile.instance.id}:collection',
          description: '',
          collaborative: false,
          isUserSavedTracksPlaylist: true,
          tracks: tracks,
          total: userSavedPlaylistTracks.data['total'],
          images: [
            Image(
              height: 300,
              width: 300,
              url: 'https://misc.scdn.co/liked-songs/liked-songs-300.png',
            )
          ],
          owner: Owner(
            displayName: UserProfile.instance.displayName,
            id: UserProfile.instance.id,
            uri: UserProfile.instance.uri,
          ),
        );

        UserPlaylists userPlaylists =
            UserPlaylists(playlists: [savedPlaylistTracks]);

        userPlaylists.fromInstance(response.data);
        return userPlaylists;
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

      Response response;
      if (playlist.isUserSavedTracksPlaylist) {
        response = await PlaylistService().getSavedTracks(market, offset);
      } else {
        response = await PlaylistService()
            .getPlaylistTracks(playlist.id!, market, offset);
      }

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

  Future<(bool, String?)> reorderTrack(
    int rangeStart,
    int insertBefore,
    String? playlistId,
    String? snapshotId,
  ) async {
    try {
      if (playlistId == null) {
        throw Exception('The given playlistId is null or empty');
      }

      if (snapshotId == null) {
        throw Exception('The given snapshotId is null or empty');
      }

      if (insertBefore > rangeStart) {
        insertBefore++;
      }

      final response = await PlaylistService()
          .reorderTrack(rangeStart, insertBefore, playlistId, snapshotId);

      if (response.statusCode == 200) {
        return (true, response.data['snapshot_id'] as String);
      }

      return (false, null);
    } on Exception catch (e) {
      lastError = e.toString();
      state.value = PlaylistState.error;
      return (false, null);
    }
  }

  Future<Playlist> getPlaylistHeaders(
      Playlist targetPlaylist, String? market) async {
    try {
      if (targetPlaylist.id == null || targetPlaylist.id!.isEmpty) {
        throw Exception('The given playlistId is null or empty');
      }

      if (market == null) {
        throw Exception('The given market is null');
      }

      final response = await PlaylistService()
          .getPlaylistHeaders(targetPlaylist.id!, market);
      targetPlaylist.fromInstance(response.data);
      return targetPlaylist;
    } on Exception catch (e) {
      lastError = e.toString();
      state.value = PlaylistState.error;
      return Playlist();
    }
  }

  Future<bool> uploadCustomCoverImage(
      String? playlistId, Uint8List imageData) async {
    try {
      if (playlistId == null || playlistId.isEmpty) {
        throw Exception('The given playlistId is null or empty');
      }

      final response =
          await PlaylistService().uploadCustomCoverImage(playlistId, imageData);

      if (response.statusCode == 202) {
        return true;
      }
      return false;
    } on Exception catch (e) {
      lastError = e.toString();
      state.value = PlaylistState.error;
      return false;
    }
  }

  Future<bool> updatePlaylistDetails(
    String? playlistId,
    String? name,
    String? description,
    bool? private,
    bool? collaborative,
  ) async {
    try {
      if (playlistId == null || playlistId.isEmpty) {
        throw Exception('The given playlistId is null or empty');
      }
      if (private != null) {
        private = !private;
      }

      final response = await PlaylistService().updatePlaylistDetails(
          playlistId, name, description, private, collaborative);

      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } on Exception catch (e) {
      lastError = e.toString();
      state.value = PlaylistState.error;
      return false;
    }
  }
}
