<<<<<<< Updated upstream
import 'package:colab_helper_for_spotify/features/auth/auth_controller.dart';
import 'package:colab_helper_for_spotify/features/home/home_page.dart';
=======
import 'package:colab_helper_for_spotify/shared/controllers/playlist_controller.dart';
>>>>>>> Stashed changes
import 'package:colab_helper_for_spotify/shared/controllers/user_controller.dart';
import 'package:colab_helper_for_spotify/shared/static/color_schemes.g.dart';
import 'package:colab_helper_for_spotify/shared/static/text_theme.g.dart';

import 'package:colab_helper_for_spotify/features/auth/auth_controller.dart';
import 'package:colab_helper_for_spotify/features/home/app_screens.dart';
import 'package:colab_helper_for_spotify/features/auth/auth_page.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ColabApp extends StatelessWidget {
  const ColabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => AuthController())),
        ChangeNotifierProvider(create: ((context) => UserController())),
        ChangeNotifierProvider(create: ((context) => PlaylistController()))
      ],
      child: MaterialApp(
        title: 'Colab Helper For Spotify',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: lightColorScheme,
          textTheme: rubikTextTheme,
        ),
        darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: darkColorScheme,
            textTheme: rubikTextTheme),
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthPage(),
<<<<<<< Updated upstream
          '/home': (context) => const HomePage()
=======
          '/app': (context) => const AppScreens(),
>>>>>>> Stashed changes
        },
      ),
    );
  }
}
