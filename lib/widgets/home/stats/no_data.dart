import 'package:financeOFF/data/financeoff_icon.dart';
import 'package:financeOFF/l10n/extension.dart';
import 'package:financeOFF/theme/theme.dart';
import 'package:financeOFF/widgets/general/button.dart';
import 'package:financeOFF/widgets/general/fin_icon.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class NoData extends StatelessWidget {
  final VoidCallback onTap;

  const NoData({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "tabs.stats.chart.noData".t(context),
              textAlign: TextAlign.center,
              style: context.textTheme.headlineMedium,
            ),
            const SizedBox(height: 8.0),
            FinIcon(
              FinIconData.icon(Symbols.query_stats_rounded),
              size: 128.0,
              color: context.colorScheme.primary,
            ),
            const SizedBox(height: 8.0),
            Button(
              trailing: const Icon(
                Symbols.history_rounded,
                weight: 600.0,
              ),
              onTap: onTap,
              child: Text("tabs.stats.timeRange.select".t(context)),
            ),
          ],
        ),
      ),
    );
  }
}
