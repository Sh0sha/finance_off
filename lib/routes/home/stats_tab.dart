import 'package:financeOFF/data/financeoff_analytic.dart';
import 'package:financeOFF/data/money_finOFF.dart';
import 'package:financeOFF/entity/category.dart';
import 'package:financeOFF/l10n/finance_localisation.dart';
import 'package:financeOFF/objectbox.dart';
import 'package:financeOFF/objectbox/actions.dart';
import 'package:financeOFF/widgets/general/spinner.dart';
import 'package:financeOFF/widgets/home/stats/group_circle_diagramma.dart';
import 'package:financeOFF/widgets/home/stats/no_data.dart';
import 'package:financeOFF/widgets/time_range_selector.dart';
import 'package:financeOFF/widgets/utils/time_and_period.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:moment_dart/moment_dart.dart';

class StatsTab extends StatefulWidget {
  const StatsTab({super.key});

  @override
  State<StatsTab> createState() => _StatsTabState();
}

class _StatsTabState extends State<StatsTab> {
  TimeRange range = TimeRange.thisMonth();

  FinoffAnalytics? analytics;

  bool busy = false;

  @override
  void initState() {
    super.initState();

    fetch(true);
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, MoneyFin> data = analytics == null
        ? {}
        : Map.fromEntries(
            analytics!.flow.entries
                .where((element) => element.value.totalExpense < 0)
                .toList()
              ..sort(
                (a, b) => b.value.totalExpense.compareTo(a.value.totalExpense),
              ),
          );

    return Column(
      children: [
        Material(
          elevation: 1.0,
          child: Container(
            padding: const EdgeInsets.all(16.0).copyWith(bottom: 8.0),
            width: double.infinity,
            child: TimeRangeSelector(
              initialValue: range,
              onChanged: updateRange,
            ),
          ),
        ),
        busy
            ? const Spinner()
            : (data.isEmpty
                ? Expanded(
                    child: NoData(
                    onTap: changeMode,
                  ))
                : Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.only(bottom: 96.0, top: 8.0),
                      child: GroupCircleDiagramma(
                        data: data,
                        unresolvedDataTitle: "category.none".t(context),
                        onReselect: (key) {
                          if (!data.containsKey(key)) return;

                          final associatedData = data[key]!.associatedData;

                          if (associatedData is Category) {
                            context.push(
                                "/category/${associatedData.id}?range=${Uri.encodeQueryComponent(range.toString())}");
                          }
                        },
                      ),
                    ),
                  )),
      ],
    );
  }

  void updateRange(TimeRange newRange) {
    setState(() {
      range = newRange;
    });

    fetch(true);
  }

  Future<void> fetch(bool byCategory) async {
    if (busy) return;

    setState(() {
      busy = true;
    });

    try {
      analytics = byCategory
          ? await ObjectBox().flowByCategories(from: range.from, to: range.to)
          : await ObjectBox().flowByAccounts(from: range.from, to: range.to);
    } finally {
      busy = false;

      if (mounted) {
        setState(() {});
      }
    }
  }

  Future<void> changeMode() async {
    final TimeRange? newRange = await showTimeRangePickerSheet(
      context,
      initialValue: range,
    );

    if (!mounted || newRange == null) return;

    setState(() {
      range = newRange;
    });
  }
}
