import '../../shared/modules/network/http.dart';

import 'dart:convert';
import 'dart:typed_data';
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

  Future<Response<dynamic>> getSavedTracks(
    String market,
    int offset,
  ) async {
    try {
      var accessToken = await storage.read(key: 'accessToken');
      final response = await dio.get(
        '/me/tracks',
        queryParameters: {'market': market, 'limit': 20, 'offset': offset},
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      return response;
    } on Exception {
      rethrow;
    }
  }

  Future<Response<dynamic>> reorderTrack(
    int rangeStart,
    int insertBefore,
    String playlistId,
    String snapshotId,
  ) async {
    try {
      var accessToken = await storage.read(key: 'accessToken');
      final response = await dio.put(
        '/playlists/$playlistId/tracks',
        data: {
          "range_start": rangeStart,
          "insert_before": insertBefore,
          "range_length": 1,
          "snapshot_id": snapshotId,
        },
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json'
        }),
      );

      return response;
    } on Exception {
      rethrow;
    }
  }

  Future<Response<dynamic>> getPlaylistHeaders(
    String playlistId,
    String market,
  ) async {
    try {
      var accessToken = await storage.read(key: 'accessToken');
      final response = await dio.get(
        '/playlists/$playlistId',
        queryParameters: {
          'market': market,
          'fields':
              'collaborative,description,external_urls,followers,href,id,images,name,type,public',
        },
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      return response;
    } on Exception {
      rethrow;
    }
  }

  Future<Response<dynamic>> uploadCustomCoverImage(
    String playlistId,
    Uint8List imageData,
  ) async {
    try {
      String base64String = base64Encode(imageData);

      var accessToken = await storage.read(key: 'accessToken');
      final response = await dio.put(
        '/playlists/$playlistId/images',
        data: base64String,
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'image/jpeg'
        }),
      );

      return response;
    } on Exception {
      rethrow;
    }
  }

  /// These two parameters [public] and [collaborative] are disabled due to Spotify API inconsistency
  Future<Response<dynamic>> updatePlaylistDetails(
    String playlistId,
    String? name,
    String? description,
    bool? public,
    bool? collaborative,
  ) async {
    try {
      var dataObject = <String, dynamic>{};

      if (name != null) {
        dataObject.addAll({'name': name});
      }

      if (description != null) {
        dataObject.addAll({'description': description});
      }

      // if (public != null) {
      //   dataObject.addAll({'public': public});
      // }

      // if (collaborative != null) {
      //   dataObject.addAll({'collaborative': collaborative});
      // }

      var accessToken = await storage.read(key: 'accessToken');
      final response = await dio.put(
        '/playlists/$playlistId',
        data: dataObject,
        options: Options(headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json'
        }),
      );

      return response;
    } on Exception {
      rethrow;
    }
  }
}
