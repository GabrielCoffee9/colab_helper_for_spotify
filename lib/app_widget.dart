import 'features/auth/auth_page.dart';
import 'features/home/app_screens.dart';
import 'shared/modules/appLocalizations/localizations_controller.dart';
import 'shared/static/color_schemes.g.dart';
import 'shared/static/text_theme.g.dart';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ColabApp extends StatelessWidget {
  const ColabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale?>(
      valueListenable: LocalizationsController.instance.currentLocale,
      builder: (context, value, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: value,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en'),
            const Locale('pt', 'BR'),
          ],
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
      },
    );
  }
}
