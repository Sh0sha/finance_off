import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:financeOFF/data/financeoff_icon.dart';
import 'package:financeOFF/data/money_finOFF.dart';
import 'package:financeOFF/entity/account.dart';
import 'package:financeOFF/entity/category.dart';
import 'package:financeOFF/l10n/finance_localisation.dart';
import 'package:financeOFF/main.dart';
import 'package:financeOFF/theme/early_colors.dart';
import 'package:financeOFF/theme/theme.dart';
import 'package:financeOFF/utils/utils.dart';
import 'package:financeOFF/widgets/general/fin_icon.dart';
import 'package:financeOFF/widgets/home/stats/legend_list_tile.dart';
import 'package:flutter/material.dart' hide Flow;

class GroupCircleDiagramma<T> extends StatefulWidget {
  final EdgeInsets chartPadding;

  final bool showSelectedSection;

  final bool showLegend;
  final bool sortLegend;

  final bool scrollLegendWithin;
  final EdgeInsets scrollPadding;

  final Map<String, MoneyFin<T>> data;

  final String? unresolvedDataTitle;

  final void Function(String key)? onReselect;

  const GroupCircleDiagramma({
    super.key,
    required this.data,
    this.chartPadding = const EdgeInsets.all(24.0),
    this.scrollPadding = EdgeInsets.zero,
    this.showLegend = true,
    this.scrollLegendWithin = false,
    this.showSelectedSection = true,
    this.sortLegend = true,
    this.unresolvedDataTitle,
    this.onReselect,
  });

  @override
  State<GroupCircleDiagramma<T>> createState() => _GroupCircleDiagrammaState<T>();
}

class _GroupCircleDiagrammaState<T> extends State<GroupCircleDiagramma<T>> {
  late Map<String, MoneyFin<T>> data;

  double get totalValue => data.values.fold<double>(
      0, (previousValue, element) => previousValue + element.totalExpense);

  bool expense = true;

  String? selectedKey;

  @override
  void initState() {
    super.initState();

    data = widget.data;
  }

  @override
  void didUpdateWidget(GroupCircleDiagramma<T> oldWidget) {
    data = widget.data;

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final MoneyFin<T>? selectedSection =
        selectedKey == null ? null : data[selectedKey!];

    final double selectedSectionProc = selectedSection == null
        ? 0.0
        : (selectedSection.totalExpense / totalValue);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showSelectedSection) ...[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                selectedSection == null
                    ? "tabs.stats.chart.select.clickToSelect".t(context)
                    : resolveName(selectedSection.associatedData),
                style: context.textTheme.headlineSmall,
              ),
              Text(
                style: TextStyle(fontSize: 18),
                  "${selectedSection?.totalExpense.abs().money ?? "-"} • ${(100 * selectedSectionProc).toStringAsFixed(1)}%"),
            ],
          ),
          const SizedBox(height: 6.0),
        ],
        Padding(
          padding: widget.chartPadding,
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 300.0,
              maxWidth: 300.0,
            ),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: LayoutBuilder(builder: (context, constraints) {
                final double size = constraints.maxWidth;

                final double centerHoleDiameter = math.min(96.0, size * 0.25);
                final double radius = (size - centerHoleDiameter) * 0.52;

                return PieChart(
                  PieChartData(
                    pieTouchData:
                        PieTouchData(touchCallback: (event, response) {
                      if (!event.isInterestedForInteractions ||
                          response == null ||
                          response.touchedSection == null) {
                        // setState(() {
                        //   selectedKey = null;
                        // });
                        return;
                      }

                      final int index =
                          response.touchedSection!.touchedSectionIndex;

                      if (index > -1) {
                        selectedKey = data.entries.elementAt(index).key;
                        setState(() {});
                      }
                    }),
                    sectionsSpace: 3.0,
                    centerSpaceRadius: centerHoleDiameter / 2,
                    startDegreeOffset: -90.0,
                    sections: data.entries.indexed
                        .map(
                          (e) => sectionData(
                            data[e.$2.key]!,
                            selected: e.$2.key == selectedKey,
                            index: e.$1,
                            radius: radius,
                          ),
                        )
                        .toList(),
                  ),
                );
              }),
            ),
          ),
        ),
        if (widget.showLegend) buildLegend(context),
      ],
    );
  }

  Widget buildLegendItem(
    BuildContext context,
    int index,
    MapEntry<String, MoneyFin<T>> entry,
  ) {
    final bool usingDarkTheme = Fin.of(context).useDarkTheme;

    final Color color = (usingDarkTheme
        ? accentColors
        : primaryColors)[index % primaryColors.length];
    final Color backgroundColor = (usingDarkTheme
        ? primaryColors
        : accentColors)[index % primaryColors.length];

    return LegendListTile(
      key: ValueKey(entry.key),
      color: color,
      leading: resolveBadgeWidget(
        entry.value.associatedData,
        color: color,
        backgroundColor: backgroundColor,
      ),
      title: Text(resolveName(entry.value.associatedData)),
      subtitle: Text((entry.value.totalExpense / totalValue).percent1),
      trailing: Text(
        entry.value.totalExpense.moneyCompact,
        style: context.textTheme.bodyLarge,
      ),
      selected: entry.key == selectedKey,
      onTap: () {
        if (widget.onReselect != null &&
            selectedKey != null &&
            selectedKey == entry.key) {
          widget.onReselect!(selectedKey!);
        } else {
          setState(() => selectedKey = entry.key);
        }
      },
    );
  }

  Widget buildLegend(BuildContext context) {
    final indexed = data.entries.toList().indexed.toList();
    if (widget.sortLegend) {
      indexed.sort(
        (a, b) => a.$2.value.totalExpense.compareTo(
          b.$2.value.totalExpense,
        ),
      );
    }

    if (widget.scrollLegendWithin) {
      return Expanded(
        child: ListView.builder(
          itemBuilder: (context, index) =>
              buildLegendItem(context, indexed[index].$1, indexed[index].$2),
          itemCount: indexed.length,
          padding: widget.scrollPadding,
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children:
          indexed.map((e) => buildLegendItem(context, e.$1, e.$2)).toList(),
    );
  }

  PieChartSectionData sectionData(
    MoneyFin<T> flow, {
    required double radius,
    bool selected = false,
    int index = 0,
  }) {
    final bool usingDarkTheme = Fin.of(context).useDarkTheme;

    final Color color = (usingDarkTheme
        ? accentColors
        : primaryColors)[index % primaryColors.length];
    final Color backgroundColor = (usingDarkTheme
        ? primaryColors
        : accentColors)[index % primaryColors.length];

    return PieChartSectionData(
      color: color,
      radius: radius,
      value: flow.totalExpense.abs(),
      title: resolveName(flow.associatedData),
      showTitle: false,
      badgeWidget: selected
          ? resolveBadgeWidget(
              flow.associatedData,
              color: color,
              backgroundColor: backgroundColor,
            )
          : null,
      badgePositionPercentageOffset: 0.8,
      borderSide: selected
          ? BorderSide(
              color: context.colorScheme.primary,
              width: 2.0,
              strokeAlign: BorderSide.strokeAlignInside,
            )
          : BorderSide.none,
    );
  }

  String resolveName(Object? entity) => switch (entity) {
        Category category => category.name,
        Account account => account.name,
        _ => widget.unresolvedDataTitle ?? "???"
      };

  Widget? resolveBadgeWidget(Object? entity,
          {Color? color, Color? backgroundColor}) =>
      switch (entity) {
        Category category => FinIcon(
            category.icon,
            plated: true,
            color: color,
            plateColor: backgroundColor ?? color?.withAlpha(0x40),
          ),
        Account account => FinIcon(
            account.icon,
            plated: true,
            color: color,
            plateColor: backgroundColor ?? color?.withAlpha(0x40),
          ),
        _ => FinIcon(
            FinIconData.emoji("?"),
            plated: true,
            color: color,
            plateColor: backgroundColor ?? color?.withAlpha(0x40),
          ),
      };
}
