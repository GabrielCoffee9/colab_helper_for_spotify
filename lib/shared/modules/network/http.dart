import '../../../features/auth/auth_controller.dart';

import 'package:dio/dio.dart';

class Http {
  static final Http _instance = Http._();
  static Http get instance => _instance;

  final dio = Dio(BaseOptions(
    baseUrl: 'https://api.spotify.com/v1',
  ));

  //UniqueInstance
  Http._() {
    dio.interceptors.add(InterceptorsWrapper(
        onError: (DioException error, ErrorInterceptorHandler handler) {
      if (error.response?.statusCode == 401) {
        AuthController.instance.getNewAccessToken();
      }

      return handler.next(error);
    }));
  }
}
