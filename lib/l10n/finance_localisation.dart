import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'extension.dart';
export 'extension.dart';

class FinLocaliz {
  final Locale locale;
  static Map<String, String> _localisationValue = {};
  static Map<String, String> _ruRU = {};

  FinLocaliz(this.locale);

  static Future<Map<String, String>> _loadLocale(Locale locale) async {
    String jsonStringValues =
        await rootBundle.loadString('assets/l10n/${locale.code}.json');
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    return mappedJson.map((key, value) => MapEntry(key, value.toString()));
  }

  Future<void> load() async {
    _localisationValue = await _loadLocale(locale);

    if (_ruRU.isEmpty) {
      if (locale.code == supportedLanguages.first.code) {
        _ruRU = {..._localisationValue};
      } else {
        _ruRU = await _loadLocale(supportedLanguages.first);
      }
    }
  }

  static String _fillFromTable(Map lookupTable, String text) {
    for (final key in lookupTable.keys) {
      text = text.replaceAll(
          "{$key}",
          lookupTable[key] is String
              ? lookupTable[key]
              : lookupTable[key].toString());
    }

    return text;
  }

  static String getTranslate(String? key, {dynamic replace}) {
    if (key == null) return "";
    if (_localisationValue.isEmpty) return "";

    final String translatedText = _localisationValue[key] ?? _ruRU[key] ?? key;

    return switch (replace) {
      null => translatedText,
      String singleValue =>
        translatedText.replaceAll(RegExp(r"{[^}]*}"), singleValue),
      num singleValue =>
        translatedText.replaceAll(RegExp(r"{[^}]*}"), singleValue.toString()),
      Map lookupTable => _fillFromTable(lookupTable, translatedText),
      _ => translatedText,
    };
  }

  String get(String? key, {dynamic replace}) =>
      getTranslate(key, replace: replace);

  static const List<Locale> supportedLanguages = [
    Locale("ru", "RU"), // Will fallback to this for unsupported locales
  ];

  static FinLocaliz of(BuildContext context) =>
      Localizations.of<FinLocaliz>(context, FinLocaliz)!;

  static int supportedLanguagesCount = supportedLanguages.length;

  static printMissingKeys() async {
    final Map<String, Map<String, String>> languages = {};
    for (Locale locale in supportedLanguages) {
      String value =
          await rootBundle.loadString('assets/l10n/${locale.code}.json');

      languages[locale.code] = (json.decode(value) as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, value.toString()));
    }
    final Set<String> keys = <String>{};
    for (var key in languages.keys) {
      keys.addAll(languages[key]!.keys);
    }

    for (var key in languages.keys) {
      final Iterable<String> missingKeys =
          keys.where((element) => !languages[key]!.keys.contains(element));
      if (missingKeys.isEmpty) {
        log("[Gegee Language Service] В $key нет недостающих ключей");
      } else {
        log("[Gegee Language Service] В $key отсутствуют ${missingKeys.length} ключей");
        for (var element in missingKeys) {
          log(element);
        }
      }
      log("-------------------");
    }
  }

  static const LocalizationsDelegate<FinLocaliz> delegate =
      _FinLocalizDelegate();
}

class _FinLocalizDelegate
    extends LocalizationsDelegate<FinLocaliz> {
  const _FinLocalizDelegate();

  @override
  bool isSupported(Locale locale) {
    return FinLocaliz.supportedLanguages.contains(locale);
  }

  @override
  Future<FinLocaliz> load(Locale locale) async {
    FinLocaliz localization = FinLocaliz(
      FinLocaliz.supportedLanguages.contains(locale)
          ? locale
          : FinLocaliz.supportedLanguages[1],
    );
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(LocalizationsDelegate<FinLocaliz> old) => false;
}
// жопосрачинк