import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocalizationsController {
  static final LocalizationsController _instance = LocalizationsController._();
  static LocalizationsController get instance => _instance;

  static AppLocalizations? of(BuildContext context) {
    return AppLocalizations.of(context);
  }

  Future<Locale?> getLocale() async {
    final SharedPreferencesWithCache prefsWithCache =
        await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );
    String? localeCode = prefsWithCache.getString('locale');
    if (localeCode == 'en') return const Locale('en');
    if (localeCode == 'pt_BR') return const Locale('pt', 'BR');
    return const Locale('en');
  }

  setLocaleFromString(String? stringLocale) {
    if (stringLocale == 'en') currentLocale.value = const Locale('en');
    if (stringLocale == 'pt_BR') currentLocale.value = const Locale('pt', 'BR');
    if (stringLocale == null) {
      currentLocale.value = const Locale('en');
    }
  }

  //UniqueInstance
  LocalizationsController._() {
    getLocale().then((value) {
      currentLocale.value = value;
    });
  }

  ValueNotifier<Locale?> currentLocale = ValueNotifier(const Locale('en'));
}
