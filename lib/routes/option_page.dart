import 'dart:developer';
import 'dart:io';

import 'package:app_settings/app_settings.dart';
import 'package:financeOFF/l10n/finance_localisation.dart';
import 'package:financeOFF/main.dart';
import 'package:financeOFF/prefs.dart';
import 'package:financeOFF/routes/preferences/language_selection_sheet.dart';
import 'package:financeOFF/theme/theme.dart';
import 'package:financeOFF/widgets/select_valyuta_list.dart';
import 'package:flutter/material.dart' hide Flow;
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

class OptionPage extends StatefulWidget {
  const OptionPage({super.key});

  @override
  State<OptionPage> createState() => _OptionPageState();
}

class _OptionPageState extends State<OptionPage> {
  bool _themeBusy = false;
  bool _currencyBusy = false;
  bool _languageBusy = false;

  @override
  Widget build(BuildContext context) {
    final ThemeMode currentThemeMode = Fin.of(context).themeMode;

    return Scaffold(
      appBar: AppBar(
        title: Text("preferences".t(context)),
      ),
      body: SafeArea(
        child: ListView(
          children: ListTile.divideTiles(
            tiles: [
              ListTile(
                title: Text("preferences.themeMode".t(context)),
                leading: switch (currentThemeMode) {
                  ThemeMode.system => const Icon(Symbols.routine_rounded),
                  ThemeMode.dark => const Icon(Symbols.light_mode_rounded),
                  ThemeMode.light => const Icon(Symbols.dark_mode_rounded),
                },
                subtitle: Text(switch (currentThemeMode) {
                  ThemeMode.system => "preferences.themeMode.system".t(context),
                  ThemeMode.dark => "preferences.themeMode.dark".t(context),
                  ThemeMode.light => "preferences.themeMode.light".t(context),
                }),
                onTap: () => updateTheme(),
                onLongPress: () => updateTheme(ThemeMode.system),
                trailing: const Icon(Symbols.chevron_right_rounded),
              ),
              ListTile(
                title: Text("preferences.language".t(context)),
                leading: const Icon(Symbols.language_rounded),
                onTap: () => updateLanguage(),
                subtitle: Text(FinLocaliz.of(context).locale.endonym),
                trailing: const Icon(Symbols.chevron_right_rounded),
              ),
              ListTile(
                title: Text("preferences.primaryCurrency".t(context)),
                leading: const Icon(Symbols.universal_currency_alt_rounded),
                onTap: () => updatePrimaryCurrency(),
                subtitle: Text(LocalPreferences().getPrimaryCurrency()),
                trailing: const Icon(Symbols.chevron_right_rounded),
              ),

              ListTile(
                title: Text("preferences.transfer".t(context)),
                leading: const Icon(Symbols.sync_alt_rounded),
                onTap: openTransferPrefs,

                trailing: const Icon(Symbols.chevron_right_rounded),
              ),
              ListTile(
                title: Text("preferences.transactionButtonOrder".t(context)),
                leading: const Icon(Symbols.action_key_rounded),
                onTap: openTransactionButtonOrderPrefs,

                trailing: const Icon(Symbols.chevron_right_rounded),
              ),
            ],
            color: context.colorScheme.onSurface.withAlpha(0x20),
          ).toList(),
        ),
      ),
    );
  }

  void updateTheme([ThemeMode? force]) async {
    if (_themeBusy) return;

    setState(() {
      _themeBusy = true;
    });

    try {
      final ThemeMode newThemeMode = force ??
          switch ((Fin.of(context).themeMode, Fin.of(context).useDarkTheme)) {
            (ThemeMode.light, _) => ThemeMode.dark,
            (ThemeMode.dark, _) => ThemeMode.light,
            (ThemeMode.system, true) => ThemeMode.light,
            (ThemeMode.system, false) => ThemeMode.dark,
          };

      await LocalPreferences().themeMode.set(newThemeMode);

      if (mounted) {
        // Even tho the whole app state refreshes, it doesn't get refreshed
        // if we switch from same ThemeMode as system from ThemeMode.system.
        // So this call is necessary
        setState(() {});
      }
    } finally {
      _themeBusy = false;
    }
  }

  void updateLanguage() async {
    if (Platform.isIOS) {
      LocalPreferences().localeOverride.remove().catchError((e) {
        log("[PreferencesPage] failed to remove locale override: $e");
        return false;
      });
      try {
        AppSettings.openAppSettings(type: AppSettingsType.appLocale);
        return;
      } catch (e) {
        log("[PreferencesPage] failed to open system app settings on iOS: $e");
      }
    }

    if (_languageBusy) return;

    setState(() {
      _languageBusy = true;
    });

    try {
      Locale current = LocalPreferences().localeOverride.get() ??
          FinLocaliz.supportedLanguages.first;

      final selected = await showModalBottomSheet<Locale>(
        context: context,
        builder: (context) => LanguageSelectionSheet(
          currentLocale: current,
        ),
      );

      if (selected != null) {
        await LocalPreferences().localeOverride.set(selected);
      }
    } finally {
      _languageBusy = false;
    }
  }

  void updatePrimaryCurrency() async {
    if (_currencyBusy) return;

    setState(() {
      _currencyBusy = true;
    });

    try {
      String current = LocalPreferences().getPrimaryCurrency();

      final selected = await showModalBottomSheet<String>(
        context: context,
        builder: (context) => SelectValyutaList(currentlySelected: current),
      );

      if (selected != null) {
        await LocalPreferences().primaryCurrency.set(selected);
      }
    } finally {
      _currencyBusy = false;
    }
  }

  void openNumpadPrefs() async {
    await context.push("/preferences/numpad");

    // Rebuild to update description text
    if (mounted) setState(() {});
  }

  void openTransferPrefs() async {
    await context.push("/preferences/transfer");
  }

  void openTransactionButtonOrderPrefs() async {
    await context.push("/preferences/transactionButtonOrder");
  }
}
