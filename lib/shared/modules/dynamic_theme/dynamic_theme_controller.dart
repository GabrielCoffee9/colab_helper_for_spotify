import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DynamicThemeController {
  static final DynamicThemeController _instance = DynamicThemeController._();
  static DynamicThemeController get instance => _instance;

  static AppLocalizations? of(BuildContext context) {
    return AppLocalizations.of(context);
  }

  Future<ThemeMode?> getTheme() async {
    final SharedPreferencesWithCache prefsWithCache =
        await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );
    String? localeCode = prefsWithCache.getString('theme');
    if (localeCode == 'light') return ThemeMode.light;
    if (localeCode == 'dark') return ThemeMode.dark;
    return ThemeMode.system;
  }

  setThemeModeFromString(String? stringThemeMode) {
    if (stringThemeMode == 'light') currentThemeMode.value = ThemeMode.light;
    if (stringThemeMode == 'dark') currentThemeMode.value = ThemeMode.dark;
    if (stringThemeMode == 'system' || stringThemeMode == null) {
      currentThemeMode.value = ThemeMode.system;
    }
  }

  //UniqueInstance
  DynamicThemeController._() {
    getTheme().then((value) {
      currentThemeMode.value = value;
    });
  }

  ValueNotifier<ThemeMode?> currentThemeMode = ValueNotifier(ThemeMode.system);
}
