import 'package:colab_helper_for_spotify/shared/static/color_schemes.g.dart';
import 'package:colab_helper_for_spotify/shared/static/text_theme.g.dart';
import 'package:colab_helper_for_spotify/features/home/app_screens.dart';
import 'package:colab_helper_for_spotify/features/auth/auth_page.dart';
import 'package:flutter/material.dart';

class ColabApp extends StatelessWidget {
  const ColabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
        '/': (context) => AuthPage(),
        '/app': (context) => const AppScreens(),
      },
    );
  }
}
