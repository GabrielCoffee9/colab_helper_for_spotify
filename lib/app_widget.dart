import 'features/auth/auth_page.dart';
import 'features/home/app_screens.dart';
import 'shared/modules/appLocalizations/localizations_controller.dart';
import 'shared/modules/dynamic_theme/dynamic_theme_controller.dart';
import 'shared/static/color_schemes.g.dart';
import 'shared/static/text_theme.g.dart';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ColabApp extends StatefulWidget {
  const ColabApp({super.key});

  @override
  State<ColabApp> createState() => _ColabAppState();
}

class _ColabAppState extends State<ColabApp> {
  LocalizationsController localizationsController =
      LocalizationsController.instance;
  DynamicThemeController dynamicThemeController =
      DynamicThemeController.instance;

  late Locale? currentLocale;
  late ThemeMode currentThemeMode;
  @override
  void initState() {
    super.initState();

    currentLocale = localizationsController.currentLocale.value;
    currentThemeMode =
        dynamicThemeController.currentThemeMode.value ?? ThemeMode.system;

    localizationsController.currentLocale.addListener(() {
      if (mounted) {
        setState(() {
          currentLocale = localizationsController.currentLocale.value;
        });
      }
    });

    dynamicThemeController.currentThemeMode.addListener(() {
      if (mounted) {
        setState(() {
          currentThemeMode =
              dynamicThemeController.currentThemeMode.value ?? ThemeMode.system;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: currentLocale,
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
      themeMode: currentThemeMode,
      initialRoute: '/',
      routes: {
        '/': (context) => AuthPage(),
        '/app': (context) => const AppScreens(),
      },
    );
  }
}
