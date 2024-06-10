import 'package:financeOFF/entity/transaction.dart';
import 'package:financeOFF/l10n/extension.dart';
import 'package:financeOFF/objectbox/actions.dart';
import 'package:financeOFF/prefs.dart';
import 'package:financeOFF/theme/helpers.dart';
import 'package:financeOFF/utils/utils.dart';
import 'package:financeOFF/widgets/operation_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moment_dart/moment_dart.dart';

class GroupedTransactionList extends StatelessWidget {
  final EdgeInsets listPadding;
  final EdgeInsets itemPadding;

  /// Когда ноль, то же самое, что и[itemPadding]
  final EdgeInsets? headerPadding;

  /// Верхнее дополнение для первого заголовка
  final double firstHeaderTopPadding;

  /// Ожидает, что [transactions] будут отсортированы от самых старых к самым новым.
  final Map<TimeRange, List<Transaction>> transactions;

  final Widget Function(TimeRange range, List<Transaction> transactions)
      headerBuilder;

  /// Разделитель для отображения между будущими/прошлыми транзакциями. Как это разделено
  /// основан на[anchor]
  final Widget? futureDivider;

  /// Используется для определения того, какие транзакции считаются будущими или прошлыми.
  ///
  /// Пока только[futureDivider] использует это
  final DateTime? anchor;

  /// Если установлено значение true, одна сторона транзакций отображается как пустая. [Container]s
  final bool shouldCombineTransferIfNeeded;

  final ScrollController? controller;

  final Widget? header;

  final bool implyHeader;

  const GroupedTransactionList({
    super.key,
    required this.transactions,
    required this.headerBuilder,
    this.controller,
    this.header,
    this.futureDivider,
    this.anchor,
    this.headerPadding,
    this.implyHeader = true,
    this.listPadding = const EdgeInsets.symmetric(vertical: 16.0),
    this.itemPadding = const EdgeInsets.symmetric(
      horizontal: 16.0,
      vertical: 4.0,
    ),
    this.firstHeaderTopPadding = 8.0,
    this.shouldCombineTransferIfNeeded = false,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime anchor = this.anchor ?? DateTime.now();

    final bool combineTransfers = shouldCombineTransferIfNeeded &&
        LocalPreferences().combineTransferTransactions.get();

    final Map<TimeRange, List<Transaction>> past = Map.fromEntries(transactions
        .entries
        .where((element) => element.key.from.isPastAnchored(anchor)));

    final Map<TimeRange, List<Transaction>> future = Map.fromEntries(
        transactions.entries
            .where((element) => !element.key.from.isPastAnchored(anchor)));

    final Widget? header = this.header ??
        (implyHeader
            ? _getImpliedHeader(context, futureTransactions: future)
            : null);

    final List<Object> flattened = [
      if (header != null) header,
      for (final entry in future.entries) ...[
        headerBuilder(entry.key, entry.value),
        ...entry.value,
      ],
      if (futureDivider != null && past.isNotEmpty && future.isNotEmpty)
        futureDivider!,
      for (final entry in past.entries) ...[
        headerBuilder(entry.key, entry.value),
        ...entry.value,
      ],
    ];

    final EdgeInsets headerPadding = this.headerPadding ?? itemPadding;

    return ListView.builder(
      controller: controller,
      padding: listPadding,
      itemBuilder: (context, index) => switch (flattened[index]) {
        (Widget header) => Padding(
            padding: headerPadding.copyWith(
              top: index == 0 ? firstHeaderTopPadding : headerPadding.top,
            ),
            child: header,
          ),
        (Transaction transaction) => TransactionListTile(
            combineTransfers: combineTransfers,
            transaction: transaction,
            padding: itemPadding,
            dismissibleKey: ValueKey(transaction.id),
            deleteFn: () => deleteTransaction(context, transaction),
          ),
        (_) => Container(),
      },
      itemCount: flattened.length,
    );
  }

  Future<void> deleteTransaction(
    BuildContext context,
    Transaction transaction,
  ) async {
    final String txnTitle =
        transaction.title ?? "transaction.fallbackTitle".t(context);

    final confirmation = await context.showConfirmDialog(
      isDeletionConfirmation: true,
      title: "general.delete.confirmName".t(context, txnTitle),
    );

    if (confirmation == true) {
      transaction.delete();
    }
  }

  Widget? _getImpliedHeader(
    BuildContext context, {
    required Map<TimeRange, List<Transaction>>? futureTransactions,
  }) {
    if (futureTransactions == null || futureTransactions.isEmpty) return null;

    final int count = futureTransactions.values.fold<int>(
      0,
      (previousValue, element) => previousValue + element.renderableCount,
    );

    return Row(
      children: [
        Expanded(
          child: Text(
            "tabs.home.upcomingTransactions".t(context, count),
            style: context.textTheme.bodyLarge?.semi(context),
          ),
        ),
        const SizedBox(width: 16.0),
        TextButton(
          onPressed: () => context.push("/transactions/upcoming"),
          child: Text(
            "tabs.home.upcomingTransactions.seeAll".t(context),
          ),
        )
      ],
    );
  }
}
