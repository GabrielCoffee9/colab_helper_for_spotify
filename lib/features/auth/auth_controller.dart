import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

enum AuthState { idle, success, error, loading }

class AuthController extends ChangeNotifier {
  var state = AuthState.idle;

  final String _appClientId = "5627bf76539f4ea5aaa3118e7116760f";
  final String _appRedirectURI = "http://localhost:8888/callback";

  final String _scope = 'ugc-image-upload,'
      'user-modify-playback-state,'
      'user-read-playback-state,'
      'user-read-currently-playing,'
      'user-follow-modify,'
      'user-follow-read,'
      'user-read-recently-played,'
      'user-read-playback-position,'
      'user-top-read,'
      'playlist-read-collaborative,'
      'playlist-modify-public,'
      'playlist-read-private,'
      'playlist-modify-private,'
      'app-remote-control,'
      'user-read-email,'
      'user-read-private,'
      'user-library-modify,'
      'user-library-read';

  var storage = const FlutterSecureStorage();

  verifySync() async {
    String? accessTokenValue = await storage.read(key: 'accessToken');

    var tokenCheck = accessTokenValue != null ? true : false;

    if (!tokenCheck) {
      await getToken();
    }
    state = AuthState.success;
    notifyListeners();
    state = AuthState.idle;
  }

  getToken() async {
    state = AuthState.loading;
    notifyListeners();
    try {
      var accessToken = await SpotifySdk.getAccessToken(
          clientId: _appClientId, redirectUrl: _appRedirectURI, scope: _scope);

      await storage.delete(key: 'accessToken');
      await storage.write(key: 'accessToken', value: accessToken);
    } on Exception {
      state = AuthState.error;
      notifyListeners();
    }
  }
}
