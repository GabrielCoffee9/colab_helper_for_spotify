import '../../models/primary models/search_items.dart';
import '../../shared/modules/network/http.dart';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SearchSpotifyService {
  final dio = Http.instance.dio;
  var storage = const FlutterSecureStorage();

  SearchSpotifyService();

  Future<Response<dynamic>> searchSpotifyContent(
      String query, String types, String market, int limit, int offset,
      {SearchItems? mergeItems}) async {
    try {
      var accessToken = await storage.read(key: 'accessToken');
      final response = await dio.get(
        '/search',
        queryParameters: {
          'q': query,
          'type': types,
          'market': market,
          'limit': limit,
          'offset': offset
        },
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      return response;
    } catch (e) {
      rethrow;
    }
  }
}
