import 'auth_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

enum AuthState { idle, success, error, loading }

class AuthController extends ChangeNotifier {
  var state = ValueNotifier(AuthState.idle);

  var storage = const FlutterSecureStorage();

  Future<bool> verifySync() async {
    String? accessTokenValue = await storage.read(key: 'accessToken');
    String? accessTokenDate = await storage.read(key: 'accessTokenDate');

    bool validToken = isValidToken(accessTokenValue, accessTokenDate);

    if (!validToken) {
      await storage.delete(key: 'accessToken');
      await storage.delete(key: 'accessTokenDate');

      state.value = AuthState.loading;

      var newToken = await AuthService().getToken();

      if (newToken.isEmpty) {
        state.value = AuthState.error;
        state.value = AuthState.idle;
        return false;
      }

      await storage.write(key: 'accessToken', value: newToken);
      await storage.write(
          key: 'accessTokenDate',
          value: DateTime.now().millisecondsSinceEpoch.toString());
    }

    state.value = AuthState.success;
    state.value = AuthState.idle;

    return true;
  }

  bool isValidToken(String? tokenValue, String? tokenDate) {
    if (tokenValue != null && tokenDate != null) {
      final actualDateTime = DateTime.now().millisecondsSinceEpoch;

      final timeDiff = (actualDateTime - int.parse(tokenDate));

      return timeDiff > 3600 ? false : true;
    }

    return false;
  }

  verifyAppConnection() async {
    bool isActive = false;
    await SpotifySdk.isSpotifyAppActive.then((value) => isActive = value);

    if (!isActive) {
      await AuthService()
          .connectSpotifyRemote(await storage.read(key: 'accessToken'));
    }
  }
}
