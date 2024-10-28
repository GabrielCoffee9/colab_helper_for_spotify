import 'features/auth/auth_page.dart';
import 'features/home/app_screens.dart';
import 'shared/static/color_schemes.g.dart';
import 'shared/static/text_theme.g.dart';

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
        textTheme: rubikTextTheme,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => AuthPage(),
        '/app': (context) => const AppScreens(),
      },
    );
  }
}
