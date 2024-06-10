import 'package:financeOFF/entity/transaction.dart' as fin_todaycard;
import 'package:financeOFF/l10n/finance_localisation.dart';
import 'package:financeOFF/objectbox/actions.dart';
import 'package:financeOFF/theme/theme.dart';
import 'package:financeOFF/widgets/home/home/analytics_card.dart';
import 'package:flutter/material.dart';
import 'package:moment_dart/moment_dart.dart';

class FinTodayCard extends StatelessWidget {
  final List<fin_todaycard.Transaction>? transactions;

  const FinTodayCard({super.key, this.transactions});

  @override
  Widget build(BuildContext context) {
    final double flow = transactions == null
        ? 0
        : transactions!
            .where((element) =>
                element.transactionDate >= DateTime.now().startOfDay() &&
                element.transactionDate <= DateTime.now())
            .sum;

    return AnalyticsCard(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 12.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "tabs.home.flowToday".t(context),
              style: context.textTheme.bodyMedium,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Flexible(
              child: Text(
                flow.moneyCompact,
                style: context.textTheme.displaySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
