import 'package:financeOFF/data/money_finOFF.dart';
import 'package:financeOFF/entity/category.dart';
import 'package:financeOFF/entity/transaction.dart';
import 'package:financeOFF/l10n/extension.dart';
import 'package:financeOFF/objectbox.dart';
import 'package:financeOFF/objectbox/actions.dart';
import 'package:financeOFF/objectbox/objectbox.g.dart';
import 'package:financeOFF/routes/error_page.dart';
import 'package:financeOFF/widgets/category/operations_info.dart';
import 'package:financeOFF/widgets/finance_card.dart';
import 'package:financeOFF/widgets/general/spinner.dart';
import 'package:financeOFF/widgets/group_operation_list.dart';
import 'package:financeOFF/widgets/home/transactions_date_header.dart';
import 'package:financeOFF/widgets/no_result.dart';
import 'package:financeOFF/widgets/time_range_selector.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:moment_dart/moment_dart.dart';

class CategoryPage extends StatefulWidget {
  static const EdgeInsets _defaultHeaderPadding = EdgeInsets.fromLTRB(
    16.0,
    16.0,
    16.0,
    8.0,
  );

  final int categoryId;
  final TimeRange? initialRange;

  final EdgeInsets headerPadding;
  final EdgeInsets listPadding;

  const CategoryPage({
    super.key,
    required this.categoryId,
    this.initialRange,
    this.listPadding = const EdgeInsets.symmetric(vertical: 16.0),
    this.headerPadding = _defaultHeaderPadding,
  });

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool busy = false;

  QueryBuilder<Transaction> qb(TimeRange range) => ObjectBox()
      .box<Transaction>()
      .query(
        Transaction_.category.equals(category!.id).and(
              Transaction_.transactionDate.betweenDate(
                range.from,
                range.to,
              ),
            ),
      )
      .order(Transaction_.transactionDate, flags: Order.descending);

  late Category? category;

  late TimeRange range;

  @override
  void initState() {
    super.initState();

    category = ObjectBox().box<Category>().get(widget.categoryId);
    range = widget.initialRange ?? TimeRange.thisMonth();
  }

  @override
  Widget build(BuildContext context) {
    if (this.category == null) return const ErrorPage();

    final Category category = this.category!;

    return StreamBuilder<List<Transaction>>(
      stream: qb(range)
          .watch(triggerImmediately: true)
          .map((event) => event.find()),
      builder: (context, snapshot) {
        final List<Transaction>? transactions = snapshot.data;

        final bool noTransactions = (transactions?.length ?? 0) == 0;

        final MoneyFin flow = transactions?.flow ?? MoneyFin();

        const double firstHeaderTopPadding = 0.0;

        final Widget header = Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TimeRangeSelector(
              initialValue: range,
              onChanged: onRangeChange,
            ),
            const SizedBox(height: 8.0),
            OperationsInfo(
              count: transactions?.length,
              flow: flow.flow,
              icon: category.icon,
            ),
            const SizedBox(height: 12.0),
            Row(
              children: [
                Expanded(
                  child: FlowCard(
                    flow: flow.totalIncome,
                    type: TransactionType.dohod,
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: FlowCard(
                    flow: flow.totalExpense,
                    type: TransactionType.rashod,
                  ),
                ),
              ],
            ),
          ],
        );

        final EdgeInsets headerPaddingOutOfList = widget.headerPadding +
            widget.listPadding.copyWith(bottom: 0, top: 0) +
            const EdgeInsets.only(top: firstHeaderTopPadding);

        return Scaffold(
          appBar: AppBar(
            title: Text(category.name),
            actions: [
              IconButton(
                icon: const Icon(Symbols.edit_rounded),
                onPressed: () => edit(),
                tooltip: "general.edit".t(context),
              ),
            ],
          ),
          body: SafeArea(
            child: switch (busy) {
              true => Padding(
                  padding: headerPaddingOutOfList,
                  child: Column(
                    children: [
                      header,
                      const Expanded(child: Spinner.center()),
                    ],
                  ),
                ),
              false when noTransactions => Padding(
                  padding: headerPaddingOutOfList,
                  child: Column(
                    children: [
                      header,
                      const Expanded(child: NoResult()),
                    ],
                  ),
                ),
              _ => GroupedTransactionList(
                  header: header,
                  transactions: transactions?.groupByDate() ?? {},
                  listPadding: widget.listPadding,
                  headerPadding: widget.headerPadding,
                  firstHeaderTopPadding: firstHeaderTopPadding,
                  headerBuilder: (range, rangeTransactions) =>
                      TransactionListDateHeader(
                    transactions: rangeTransactions,
                    date: range.from,
                  ),
                )
            },
          ),
        );
      },
    );
  }

  void onRangeChange(TimeRange newRange) {
    setState(() {
      range = newRange;
    });
  }

  Future<void> edit() async {
    await context.push("/category/${category!.id}/edit");

    category = ObjectBox().box<Category>().get(widget.categoryId);

    if (mounted) {
      setState(() {});
    }
  }
}
