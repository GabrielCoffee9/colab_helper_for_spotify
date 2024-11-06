import '../../shared/modules/network/http.dart';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PlaylistService {
  final dio = Http.instance.dio;
  var storage = const FlutterSecureStorage();

  PlaylistService();

  Future<Response<dynamic>> getCurrentUserPlaylists(int limit, offset) async {
    try {
      var accessToken = await storage.read(key: 'accessToken');
      final response = await dio.get(
        '/me/playlists',
        queryParameters: {
          'limit': limit,
          'offset': offset,
        },
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        }, contentType: Headers.jsonContentType),
      );

      return response;
    } on Exception {
      rethrow;
    }
  }

  Future<Response<dynamic>> getPlaylistTracks(
    String playlistId,
    String market,
    int offset,
  ) async {
    try {
      var accessToken = await storage.read(key: 'accessToken');
      final response = await dio.get(
        '/playlists/$playlistId/tracks',
        queryParameters: {
          'limit': 50,
          'market': market,
          'offset': offset,
        },
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      return response;
    } on Exception {
      rethrow;
    }
  }

  Future<Response<dynamic>> searchPlaylists(
    String query,
    String market,
    int offset,
  ) async {
    try {
      var accessToken = await storage.read(key: 'accessToken');
      final response = await dio.get(
        '/search',
        queryParameters: {
          'q': query,
          'type': 'playlist',
          'market': market,
          'limit': 20,
          'offset': offset
        },
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      return response;
    } on Exception {
      rethrow;
    }
  }

  Future<Response<dynamic>> checkIfCurrentUserFollowsPlaylist(
      String playlistId) async {
    try {
      var accessToken = await storage.read(key: 'accessToken');
      final response = await dio.get(
        '/playlists/$playlistId/followers/contains',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      return response;
    } on Exception {
      rethrow;
    }
  }
}
