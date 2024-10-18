import 'auth_service.dart';

import 'package:spotify_sdk/models/connection_status.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum AuthState { idle, success, error, loading }

class AuthController {
  static final AuthController _instance = AuthController._();
  static AuthController get instance => _instance;

  //UniqueInstance
  AuthController._();

  var state = ValueNotifier(AuthState.idle);

  var storage = const FlutterSecureStorage();

  Stream<ConnectionStatus> connectionStatus =
      SpotifySdk.subscribeConnectionStatus().asBroadcastStream();

  String? lastError;

  Future<bool> syncSpotifyRemote({bool forceTokenRefresh = false}) async {
    try {
      bool validToken;
      String? accessTokenValue = await storage.read(key: 'accessToken');

      if (forceTokenRefresh) {
        validToken = false;
      } else {
        String? accessTokenDate = await storage.read(key: 'accessTokenDate');
        validToken = isValidToken(accessTokenValue, accessTokenDate);
      }

      if (!validToken) {
        await storage.delete(key: 'accessToken');
        await storage.delete(key: 'accessTokenDate');

        return await AuthService().getNewTokenAndConnectToSpotifyRemote();
      } else {
        return await AuthService().connectSpotifyRemote(accessTokenValue);
      }
    } on Exception catch (error) {
      lastError = error.toString();
      return false;
    }
  }

  bool isValidToken(String? tokenValue, String? tokenDate) {
    try {
      if (tokenValue != null && tokenDate != null) {
        final actualDateTime = DateTime.now().millisecondsSinceEpoch;

        final timeDiff = (actualDateTime - int.parse(tokenDate));

        return timeDiff > 3600 ? false : true;
      }

      return false;
    } on Exception {
      rethrow;
    }
  }

  Future<bool> disconnectSpotifyRemote() async {
    try {
      return await AuthService().disconnectSpotifyRemote();
    } on Exception {
      rethrow;
    }
  }

  // verifyAppConnection() async {
  //   bool isActive = false;
  //   await SpotifySdk.isSpotifyAppActive.then((value) => isActive = value);

  //   if (!isActive) {
  //     await AuthService()
  //         .connectSpotifyRemote(await storage.read(key: 'accessToken'));
  //   }
  // }
}
