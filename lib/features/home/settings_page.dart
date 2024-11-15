import '../../shared/modules/appLocalizations/localizations_controller.dart';

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

  Future<void> setLocale(String newSetting) async {
    final SharedPreferencesWithCache prefsWithCache =
        await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );
    prefsWithCache.setString('locale', newSetting);
    LocalizationsController.instance.setLocaleFromString(newSetting);
  }

  @override
  void initState() {
    super.initState();

    getLocale().then((value) {
      setState(() {
        groupValue = value;
      });
    });
  }

  String groupValue = '';
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
            groupValue: groupValue,
            onChanged: (String? value) {
              setState(() {
                groupValue = value!;
                setLocale(value);
              });
            },
          ),
          RadioListTile(
            title:
                Text(LocalizationsController.of(context)!.portugueseBrazilian),
            value: 'pt_BR',
            groupValue: groupValue,
            onChanged: (String? value) {
              setState(() {
                groupValue = value!;
                setLocale(value);
              });
            },
          ),
        ],
      ),
    );
  }
}
