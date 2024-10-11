import 'auth_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:spotify_sdk/spotify_sdk.dart';

enum AuthState { idle, success, error, loading }

class AuthController extends ChangeNotifier {
  var state = ValueNotifier(AuthState.idle);

  var storage = const FlutterSecureStorage();

  String? lastError;

  Future<bool> syncSpotifyRemote({bool forceTokenRefresh = false}) async {
    try {
      bool validToken;

      if (forceTokenRefresh) {
        validToken = false;
      } else {
        String? accessTokenValue = await storage.read(key: 'accessToken');
        String? accessTokenDate = await storage.read(key: 'accessTokenDate');

        validToken = isValidToken(accessTokenValue, accessTokenDate);
      }

      if (!validToken) {
        await storage.delete(key: 'accessToken');
        await storage.delete(key: 'accessTokenDate');

        state.value = AuthState.loading;

        var newToken =
            await AuthService().getNewTokenAndConnectToSpotifyRemote();

        if (newToken.isEmpty) {
          lastError = 'Error at getToken Function';
          state.value = AuthState.error;
          return false;
        }
      }

      state.value = AuthState.success;
      lastError = '';
      return true;
    } on Exception catch (error) {
      lastError = error.toString();
      state.value = AuthState.error;
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

  // verifyAppConnection() async {
  //   bool isActive = false;
  //   await SpotifySdk.isSpotifyAppActive.then((value) => isActive = value);

  //   if (!isActive) {
  //     await AuthService()
  //         .connectSpotifyRemote(await storage.read(key: 'accessToken'));
  //   }
  // }
}
