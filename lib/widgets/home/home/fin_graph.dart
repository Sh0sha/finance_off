import 'package:financeOFF/entity/transaction.dart';
import 'package:financeOFF/l10n/finance_localisation.dart';
import 'package:financeOFF/theme/theme.dart';
import 'package:financeOFF/widgets/home/home/analytics_card.dart';
import 'package:financeOFF/widgets/home/home/fin_diagramma.dart';
import 'package:flutter/material.dart';

class FinGraph extends StatelessWidget {
  final DateTime startDate;

  final List<Transaction>? transactions;

  const FinGraph({
    super.key,
    this.transactions,
    required this.startDate,
  });

  @override
  Widget build(BuildContext context) {
    return AnalyticsCard(
      child: Padding(
        padding: const EdgeInsets.all(16.0).copyWith(top: 12.0),
        child: Column(
          children: [
            Text(
              "tabs.home.last7days".t(context),
              style: context.textTheme.headlineSmall,
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: FinDiagramma(
                transactions: transactions ?? [],
                startDate: startDate,
                endDate: DateTime.now(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
