import 'dart:io';


import 'package:financeOFF/entity/profile.dart';
import 'package:financeOFF/entity/transaction.dart';
import 'package:financeOFF/l10n/finance_localisation.dart';
import 'package:financeOFF/objectbox.dart';
import 'package:financeOFF/objectbox/actions.dart';
import 'package:financeOFF/prefs.dart';
import 'package:financeOFF/routes.dart';
import 'package:financeOFF/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:pie_menu/pie_menu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ObjectBox.initialize();
  await LocalPreferences.initialize();
  await ObjectBox().updateAccountOrderList(ignoreIfNoUnsetValue: true);

  runApp(const Fin());
}

class Fin extends StatefulWidget {
  const Fin({super.key});

  @override
  State<Fin> createState() => FinState();

  static FinState of(BuildContext context) =>
      context.findAncestorStateOfType<FinState>()!;
}

class FinState extends State<Fin> {
  Locale _locale = FinLocaliz.supportedLanguages.first;
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  bool get useDarkTheme => (_themeMode == ThemeMode.system
      ? (MediaQuery.platformBrightnessOf(context) == Brightness.dark)
      : (_themeMode == ThemeMode.dark));

  PieTheme get pieTheme {
    return useDarkTheme ? pieThemeDark : pieThemeLight;
  }

  @override
  void initState() {
    super.initState();

    _reloadLocale();
    _reloadTheme();

    LocalPreferences().localeOverride.addListener(_reloadLocale);
    LocalPreferences().themeMode.addListener(_reloadTheme);

    ObjectBox().box<Transaction>().query().watch().listen((event) {
      ObjectBox().invalidateAccountsTab();
    });

    if (ObjectBox().box<Profile>().count(limit: 1) == 0) {
      Profile.createDefaultProfile();
    }
  }

  @override
  void dispose() {
    LocalPreferences().localeOverride.removeListener(_reloadLocale);
    LocalPreferences().themeMode.removeListener(_reloadTheme);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      onGenerateTitle: (context) => "appName".t(context),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FinLocaliz.delegate,
      ],
      supportedLocales: FinLocaliz.supportedLanguages,
      locale: LocalPreferences().localeOverride.value,
      routerConfig: router,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: _themeMode,
      debugShowCheckedModeBanner: false,
    );
  }

  void _reloadTheme() {
    setState(() {
      _themeMode = LocalPreferences().themeMode.value ?? _themeMode;
    });
  }

  void _reloadLocale() {
    _locale = LocalPreferences().localeOverride.value ?? _locale;
    Moment.setGlobalLocalization(
      MomentLocalizations.byLocale(_locale.code) ?? MomentLocalizations.enUS(),
    );
    Intl.defaultLocale = _locale.code;
    setState(() {});
  }
}
