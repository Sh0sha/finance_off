library iso4217_currencies;

import 'package:financeOFF/utils/utils.dart';

class CurrencyData {

  final String code;


  final String country;

  final String name;

  const CurrencyData({
    required this.code,
    required this.country,
    required this.name,
  });
}

final List<CurrencyData> iso4217Currencies = [

  const CurrencyData(
    country: "RUSSIAN FEDERATION (THE)",
    name: "Russian Ruble",
    code: "RUB",
  ),
  const CurrencyData(
    country: "UNITED STATES OF AMERICA (THE)",
    name: "US Dollar",
    code: "USD",
  ),
];

final Map<String, String> _multinationCurrencyCountryNameOverride = {
  "USD": "US AND OTHERS",
};

final Map<String, CurrencyData> iso4217CurrenciesGrouped =
    iso4217Currencies.groupBy((currencyData) => currencyData.code).map(
  (key, value) {
    return MapEntry(
      key,
      CurrencyData(
        code: value.first.code,
        country: _multinationCurrencyCountryNameOverride[value.first.code] ??
            value.map((e) => e.country).join(", "),
        name: value.first.name,
      ),
    );
  },
);
