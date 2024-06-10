import 'package:financeOFF/entity/transaction.dart';
import 'package:financeOFF/l10n/extension.dart';
import 'package:financeOFF/objectbox/actions.dart';
import 'package:financeOFF/theme/theme.dart';
import 'package:flutter/widgets.dart';
import 'package:moment_dart/moment_dart.dart';

class TransactionListDateHeader extends StatelessWidget {
  final DateTime date;
  final List<Transaction> transactions;

  ///Скрывает подсчет и поток
  final bool future;

  const TransactionListDateHeader({
    super.key,
    required this.transactions,
    required this.date,
    this.future = false,
  });
  const TransactionListDateHeader.future({
    super.key,
    required this.date,
  })  : future = true,
        transactions = const [];

  @override
  Widget build(BuildContext context) {
    final Widget title = Text(
      date.toMoment().calendar(omitHours: true),
      style: context.textTheme.headlineMedium,
    );

    if (future) {
      return title;
    }

    final double flow = transactions.sum;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        title,
        Text(
          "${flow.moneyCompact} • ${'tabs.home.transactionsCount'.t(context, transactions.renderableCount)}",
          style: context.textTheme.labelLarge,
        ),
      ],
    );
  }
}
