import 'package:financeOFF/entity/transaction.dart';
import 'package:financeOFF/theme/fin_colors.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

extension ThemeAccessor on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  FinColors get flowColors => Theme.of(this).extension<FinColors>()!;
}

extension TextStyleHelper on TextStyle {
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);
  TextStyle semi(BuildContext context) =>
      copyWith(color: context.flowColors.semi);
}

extension TransactionTypeWidgetData on TransactionType {
  IconData get icon {
    switch (this) {
      case TransactionType.dohod:
        return Symbols.stat_2_rounded;
      case TransactionType.rashod:
        return Symbols.stat_minus_2_rounded;
      case TransactionType.transfer:
        return Symbols.compare_arrows_rounded;
    }
  }

  Color color(BuildContext context) => switch (this) {
        TransactionType.dohod => context.flowColors.dohod,
        TransactionType.rashod => context.flowColors.rashod,
        TransactionType.transfer => context.colorScheme.onSurface,
      };

  Color actionColor(BuildContext context) => switch (this) {
        TransactionType.dohod => context.colorScheme.onError,
        TransactionType.rashod => context.colorScheme.onError,
        TransactionType.transfer => context.colorScheme.onSecondary,
      };

  Color actionBackgroundColor(BuildContext context) => switch (this) {
        TransactionType.dohod => context.flowColors.dohod,
        TransactionType.rashod => context.flowColors.rashod,
        TransactionType.transfer => context.colorScheme.secondary,
      };
}
