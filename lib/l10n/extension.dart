import 'package:financeOFF/l10n/finance_localisation.dart';
import 'package:financeOFF/prefs.dart';
import 'package:flutter/widgets.dart';

import 'package:intl/intl.dart';

extension L10nHelper on BuildContext {
  FinLocaliz get l => FinLocaliz.of(this);
}


final Map<String, (String, String)> _localeNames = {
  "ru_RU": ("По умолчанию", "Русский"),
};

extension Underscore on Locale {

  String get code => [languageCode, scriptCode, countryCode].nonNulls.join("_");


  String get name => _localeNames[code]?.$1 ?? "Unknown";


  String get endonym => _localeNames[code]?.$2 ?? "Unknown";
}

extension L10nStringHelper on String {
  /// Возвращает локализованную версию [this].
  ///
  /// То же, что и вызов context.l.get([this])
  String t(BuildContext context, [dynamic replace]) =>
      context.l.get(this, replace: replace);

  /// Возвращает локализованную версию [this].
  ///
  /// То же, что и вызов context.l.get([this])
  String tr([dynamic replace]) =>
      FinLocaliz.getTranslate(this, replace: replace);
}

extension MoneyFormat on num {
  String formatMoney({
    String? currency,
    bool includeCurrency = true,
    bool useCurrencySymbol = true,
    bool compact = false,
    bool takeAbsoluteValue = false,
    int? decimalDigits,
  }) {
    final num amount = takeAbsoluteValue ? abs() : this;

    if (!includeCurrency) {
      currency = "";
      useCurrencySymbol = false;
    } else {
      currency ??= LocalPreferences().getPrimaryCurrency();
    }

    final String? symbol = useCurrencySymbol
        ? NumberFormat.simpleCurrency(
            locale: Intl.defaultLocale,
            name: currency,
          ).currencySymbol
        : null;

    if (compact) {
      return NumberFormat.compactCurrency(
        locale: Intl.defaultLocale,
        name: currency,
        symbol: symbol,
        decimalDigits: decimalDigits,
      ).format(amount);
    }

    return NumberFormat.currency(
      locale: Intl.defaultLocale,
      name: currency,
      symbol: symbol,
      decimalDigits: decimalDigits,
    ).format(amount);
  }
  /// Возвращает строку в денежном формате в основной валюте
  /// в локали по умолчанию
  ///
  /// например, $420
  String get money => formatMoney();

  /// Возвращает компактную строку в денежном формате в первичном
  //   валюта в локали по умолчанию

  String get moneyCompact => formatMoney(compact: true);

  /// Возвращает строку в денежном формате (в локали по умолчанию)
  ///
  /// например, 467 000
  String get moneyNoMarker => formatMoney(includeCurrency: false);

  /// Возвращает строку в денежном формате (в локали по умолчанию)
  ///
  /// например, 1,2M
  String get moneyNoMarkerCompact => formatMoney(
        includeCurrency: false,
        compact: true,
      );
}
