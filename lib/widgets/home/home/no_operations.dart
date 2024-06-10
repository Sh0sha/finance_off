import 'package:financeOFF/data/financeoff_icon.dart';
import 'package:financeOFF/l10n/extension.dart';
import 'package:financeOFF/theme/theme.dart';
import 'package:financeOFF/widgets/general/fin_icon.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class NoOperations extends StatelessWidget {
  final bool allTime;

  const NoOperations({super.key, this.allTime = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(

              allTime
                  ? "tabs.home.noTransactions.allTime".t(context)
                  : "tabs.home.noTransactions.last7Days".t(context),
              textAlign: TextAlign.center,
              style: context.textTheme.headlineLarge,
            ),
            const SizedBox(height: 10.0),
            FinIcon(
              FinIconData.icon(Symbols.dangerous_rounded),
              size: 100.0,
              color: context.colorScheme.primary,
            ),
            const SizedBox(height: 8.0),
            Text( style: TextStyle(fontSize: 20),
              "tabs.home.noTransactions.addSome".t(context),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
