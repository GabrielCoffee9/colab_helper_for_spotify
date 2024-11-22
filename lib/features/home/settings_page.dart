import '../../shared/modules/appLocalizations/localizations_controller.dart';
import '../../shared/modules/dynamic_theme/dynamic_theme_controller.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<String> getLocale() async {
    final SharedPreferencesWithCache prefsWithCache =
        await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );
    String? locale = prefsWithCache.getString('locale');
    if (locale == null) {
      return 'system';
    }

    return locale;
  }

  Future<String> getTheme() async {
    final SharedPreferencesWithCache prefsWithCache =
        await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );
    String? theme = prefsWithCache.getString('theme');
    if (theme == null) {
      return 'system';
    }

    return theme;
  }

  Future<void> setLocale(String newSetting) async {
    final SharedPreferencesWithCache prefsWithCache =
        await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );
    prefsWithCache.setString('locale', newSetting);
    LocalizationsController.instance.setLocaleFromString(newSetting);
  }

  Future<void> setTheme(String newSetting) async {
    final SharedPreferencesWithCache prefsWithCache =
        await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );
    prefsWithCache.setString('theme', newSetting);
    DynamicThemeController.instance.setThemeModeFromString(newSetting);
  }

  @override
  void initState() {
    super.initState();

    getLocale().then((value) {
      setState(() {
        languageGroupValue = value;
      });
    });

    getTheme().then((value) {
      setState(() {
        themeGroupValue = value;
      });
    });
  }

  String languageGroupValue = '';
  String themeGroupValue = 'system';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocalizationsController.of(context)!.settings),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              LocalizationsController.of(context)!.language,
              style: const TextStyle(fontSize: 25),
            ),
          ),
          RadioListTile(
            title: Text(LocalizationsController.of(context)!.english),
            value: 'en',
            groupValue: languageGroupValue,
            onChanged: (String? value) {
              setState(() {
                languageGroupValue = value!;
                setLocale(value);
              });
            },
          ),
          RadioListTile(
            title:
                Text(LocalizationsController.of(context)!.portugueseBrazilian),
            value: 'pt_BR',
            groupValue: languageGroupValue,
            onChanged: (String? value) {
              setState(() {
                languageGroupValue = value!;
                setLocale(value);
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              LocalizationsController.of(context)!.theme,
              style: const TextStyle(fontSize: 25),
            ),
          ),
          RadioListTile(
            title: Text(LocalizationsController.of(context)!.system),
            value: 'system',
            groupValue: themeGroupValue,
            onChanged: (String? value) {
              setState(() {
                themeGroupValue = value!;
                setTheme(value);
              });
            },
          ),
          RadioListTile(
            title: Text(LocalizationsController.of(context)!.lightMode),
            value: 'light',
            groupValue: themeGroupValue,
            onChanged: (String? value) {
              setState(() {
                themeGroupValue = value!;
                setTheme(value);
                // ColabApp.of(context).changeTheme(ThemeMode.light);
              });
            },
          ),
          RadioListTile(
            title: Text(LocalizationsController.of(context)!.darkMode),
            value: 'dark',
            groupValue: themeGroupValue,
            onChanged: (String? value) {
              setState(() {
                themeGroupValue = value!;
                setTheme(value);
                // ColabApp.of(context).changeTheme(ThemeMode.dark);
              });
            },
          ),
        ],
      ),
    );
  }
}
