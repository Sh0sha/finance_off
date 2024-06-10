import 'dart:convert';
import 'dart:developer';

import 'package:financeOFF/data/prefs/frecency.dart';
import 'package:financeOFF/entity/account.dart';
import 'package:financeOFF/entity/category.dart';
import 'package:financeOFF/entity/transaction.dart';
import 'package:financeOFF/objectbox.dart';
import 'package:financeOFF/objectbox/objectbox.g.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_settings/local_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

///Этот класс содержит все, что хранится на
/// устройство. Например, пользовательские настройки и настройки для каждого устройства.
/// настройки
class LocalPreferences {
  final SharedPreferences _prefs;

  late final PrimitiveSettingsEntry<String> primaryCurrency;
  late final BoolSettingsEntry usePhoneNumpadLayout;
  late final BoolSettingsEntry enableNumpadHapticFeedback;
  late final BoolSettingsEntry combineTransferTransactions;
  late final BoolSettingsEntry excludeTransferFromFlow;
  late final JsonListSettingsEntry<TransactionType> transactionButtonOrder;

  late final BoolSettingsEntry completedInitialSetup;

  late final ThemeModeSettingsEntry themeMode;
  late final LocaleSettingsEntry localeOverride;

  /// Использует ли пользователь только одну валюту в разных аккаунтах
  late final BoolSettingsEntry transitiveUsesSingleCurrency;

  late final DateTimeSettingsEntry transitiveLastTimeFrecencyUpdated;

  LocalPreferences._internal(this._prefs) {
    primaryCurrency = PrimitiveSettingsEntry<String>(
      key: "flow.primaryCurrency",
      preferences: _prefs,
    );
    usePhoneNumpadLayout = BoolSettingsEntry(
      key: "flow.usePhoneNumpadLayout",
      preferences: _prefs,
      initialValue: false,
    );
    enableNumpadHapticFeedback = BoolSettingsEntry(
      key: "flow.enableNumpadHapticFeedback",
      preferences: _prefs,
      initialValue: true,
    );
    combineTransferTransactions = BoolSettingsEntry(
      key: "flow.combineTransferTransactions",
      preferences: _prefs,
      initialValue: true,
    );
    excludeTransferFromFlow = BoolSettingsEntry(
      key: "flow.excludeTransferFromFlow",
      preferences: _prefs,
      initialValue: false,
    );
    transactionButtonOrder = JsonListSettingsEntry<TransactionType>(
      key: "flow.transactionButtonOrder",
      preferences: _prefs,
      removeDuplicates: true,
      initialValue: TransactionType.values,
      fromJson: (json) =>
          TransactionType.fromJson(json) ?? TransactionType.rashod,
      toJson: (transactionType) => transactionType.toJson(),
    );

    completedInitialSetup = BoolSettingsEntry(
      key: "flow.completedInitialSetup",
      preferences: _prefs,
      initialValue: false,
    );

    themeMode = ThemeModeSettingsEntry(
      key: "flow.themeMode",
      preferences: _prefs,
      initialValue: ThemeMode.system,
    );
    localeOverride = LocaleSettingsEntry(
      key: "flow.localeOverride",
      preferences: _prefs,
    );

    transitiveUsesSingleCurrency = BoolSettingsEntry(
      key: "flow.transitive.usesSingleCurrency",
      preferences: _prefs,
      initialValue: true,
    );

    transitiveLastTimeFrecencyUpdated = DateTimeSettingsEntry(
      key: "flow.transitive.lastTimeFrecencyUpdated",
      preferences: _prefs,
    );

    updateTransitiveProperties();
  }

  Future<void> updateTransitiveProperties() async {
    try {
      final accounts = await ObjectBox().box<Account>().getAllAsync();

      final usesSingleCurrency =
          accounts.map((e) => e.currency).toSet().length == 1;

      await transitiveUsesSingleCurrency.set(usesSingleCurrency);
    } catch (e) {
      log("[LocalPreferences] невозможно обновить транзитивные свойства из-за: $e");
    }

    if (transitiveLastTimeFrecencyUpdated.get() == null) {
      _reevaluateCategoryFrecency();
      _reevaluateAccountFrecency();
    }
  }

  Future<FrecencyData?> setFrecencyData(
    String type,
    String uuid,
    FrecencyData? value,
  ) async {
    final String prefixedKey = "flow.transitive.frecency.$type.$uuid";

    if (value == null) {
      await _prefs.remove(prefixedKey);
      return null;
    } else {
      await _prefs.setString(prefixedKey, jsonEncode(value.toJson()));
      return value;
    }
  }

  Future<FrecencyData?> updateFrecencyData(
    String type,
    String uuid,
  ) async {
    final FrecencyData current = getFrecencyData(type, uuid) ??
        FrecencyData(lastUsed: DateTime.now(), useCount: 0, uuid: uuid);

    return await setFrecencyData(type, uuid, current.incremented());
  }

  FrecencyData? getFrecencyData(String type, String uuid) {
    final String prefixedKey = "flow.transitive.frecency.$type.$uuid";

    final raw = _prefs.getString(prefixedKey);

    if (raw == null) return null;

    try {
      return FrecencyData.fromJson(jsonDecode(raw));
    } catch (e) {
      return null;
    }
  }

  Future<void> _reevaluateCategoryFrecency() async {
    final List<Category> categories =
        await ObjectBox().box<Category>().getAllAsync();

    if (categories.isEmpty) {
      return;
    }

    for (final category in categories) {
      try {
        final Query<Transaction> categoryTransactionsQuery = ObjectBox()
            .box<Transaction>()
            .query(Transaction_.categoryUuid.equals(category.uuid).and(
                Transaction_.transactionDate
                    .lessThan(DateTime.now().millisecondsSinceEpoch)))
            .order(Transaction_.transactionDate, flags: Order.descending)
            .build();

        final int useCount = categoryTransactionsQuery.count();
        final DateTime lastUsed =
            categoryTransactionsQuery.findFirst()?.transactionDate ??
                DateTime.fromMillisecondsSinceEpoch(0);

        categoryTransactionsQuery.close();

        // Future
        setFrecencyData(
            "category",
            category.uuid,
            FrecencyData(
              uuid: category.uuid,
              lastUsed: lastUsed,
              useCount: useCount,
            ));
      } catch (e) {
        log("Не удалось создать категорию FrecencyData для $category из-за: $e");
      }
    }
  }

  Future<void> _reevaluateAccountFrecency() async {
    final List<Account> accounts =
        await ObjectBox().box<Account>().getAllAsync();

    if (accounts.isEmpty) {
      return;
    }

    for (final account in accounts) {
      try {
        final Query<Transaction> accountTransactionsQuery = ObjectBox()
            .box<Transaction>()
            .query(Transaction_.accountUuid.equals(account.uuid).and(
                Transaction_.transactionDate
                    .lessThan(DateTime.now().millisecondsSinceEpoch)))
            .order(Transaction_.transactionDate, flags: Order.descending)
            .build();

        final int useCount = accountTransactionsQuery.count();
        final DateTime lastUsed =
            accountTransactionsQuery.findFirst()?.transactionDate ??
                DateTime.fromMillisecondsSinceEpoch(0);

        accountTransactionsQuery.close();

        // Future
        setFrecencyData(
            "account",
            account.uuid,
            FrecencyData(
              uuid: account.uuid,
              lastUsed: lastUsed,
              useCount: useCount,
            ));
      } catch (e) {
        log("Не удалось создать учетную запись FrecencyData для $account из-за: $e");
      }
    }
  }

  String getPrimaryCurrency() {
    String? primaryCurrencyName = primaryCurrency.value;

    if (primaryCurrencyName == null) {
      late final String? firstAccountCurency;

      try {
        final Query<Account> firstAccountQuery = ObjectBox()
            .box<Account>()
            .query()
            .order(Account_.createdDate)
            .build();

        firstAccountCurency = firstAccountQuery.findFirst()?.currency;

        firstAccountQuery.close();
      } catch (e) {
        firstAccountCurency = null;
      }

      if (firstAccountCurency == null) {
        // Generally, primary currency will be set up when the user first
        // opens the app. When recovering from a backup, backup logic should
        // handle setting this value.
        primaryCurrencyName =
            NumberFormat.currency(locale: Intl.defaultLocale ?? "ru_RU")
                    .currencyName ??
                "RUB";
      } else {
        primaryCurrencyName = firstAccountCurency;
      }

      primaryCurrency.set(primaryCurrencyName);
    }

    return primaryCurrencyName;
  }

  factory LocalPreferences() {
    if (_instance == null) {
      throw Exception(
        "Вы должны инициализировать LocalPreferences, вызвав Initialize().",
      );
    }

    return _instance!;
  }

  static LocalPreferences? _instance;

  static Future<void> initialize() async {
    _instance ??=
        LocalPreferences._internal(await SharedPreferences.getInstance());
  }
}
