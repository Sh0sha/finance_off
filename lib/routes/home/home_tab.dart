import 'package:financeOFF/entity/transaction.dart';
import 'package:financeOFF/objectbox.dart';
import 'package:financeOFF/objectbox/actions.dart';
import 'package:financeOFF/objectbox/objectbox.g.dart';
import 'package:financeOFF/widgets/general/wavy_divider.dart';
import 'package:financeOFF/widgets/home/home/no_operations.dart';
import 'package:financeOFF/widgets/home/greetings_bar.dart';
import 'package:financeOFF/widgets/group_operation_list.dart';
import 'package:financeOFF/widgets/home/transactions_date_header.dart';
import 'package:flutter/material.dart';
import 'package:moment_dart/moment_dart.dart';

class HomeTab extends StatefulWidget {
  final ScrollController? scrollController;

  const HomeTab({super.key, this.scrollController});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with AutomaticKeepAliveClientMixin {
  final DateTime startDate =
      Moment.now().subtract(const Duration(days: 29)).startOfDay();

  QueryBuilder<Transaction> qb() => ObjectBox()
      .box<Transaction>()
      .query(
        Transaction_.transactionDate.greaterOrEqual(
          startDate.millisecondsSinceEpoch,
        ),
      )
      .order(Transaction_.transactionDate, flags: Order.descending);

  late final bool noTransactionsAtAll;

  @override
  void initState() {
    super.initState();
    noTransactionsAtAll = ObjectBox().box<Transaction>().count(limit: 1) == 0;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return StreamBuilder<List<Transaction>>(
      stream: qb().watch(triggerImmediately: true).map((event) => event.find()),
      builder: (context, snapshot) {
        final List<Transaction>? transactions = snapshot.data;

        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: GreetingsBar(),
            ),
            switch ((transactions?.length ?? 0, snapshot.hasData)) {
              (0, true) => Expanded(
                  child: NoOperations(
                    allTime: noTransactionsAtAll,
                  ),
                ),
              (_, true) => Expanded(
                  child: buildGroupedList(context, transactions ?? []),
                ),
              (_, false) => const Expanded(
                  child: Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                ),
            }
          ],
        );
      },
    );
  }

  Widget buildGroupedList(
    BuildContext context,
    List<Transaction> transactions,
  ) {
    final Map<TimeRange, List<Transaction>> grouped =
        transactions.groupByDate();

    return GroupedTransactionList(
      controller: widget.scrollController,
      transactions: grouped,
      shouldCombineTransferIfNeeded: true,
      futureDivider: const WavyDivider(),
      listPadding: const EdgeInsets.only(
        top: 0,
        bottom: 80.0,
      ),
      headerBuilder: (
        TimeRange range,
        List<Transaction> transactions,
      ) =>
          TransactionListDateHeader(
        transactions: transactions,
        date: range.from,
        future: !range.from.isPast,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
