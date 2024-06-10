import 'package:financeOFF/data/financeoff_icon.dart';
import 'package:financeOFF/l10n/extension.dart';
import 'package:financeOFF/theme/theme.dart';
import 'package:financeOFF/widgets/general/fin_icon.dart';
import 'package:financeOFF/widgets/general/area.dart';
import 'package:flutter/material.dart';

class OperationsInfo extends StatelessWidget {
  final int? count;
  final double flow;

  final FinIconData icon;

  const OperationsInfo({
    super.key,
    required this.count,
    required this.flow,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Area(builder: (context) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 4.0),
          FinIcon(icon, size: 48.0, plated: true),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    flow.money,
                    style: context.textTheme.displaySmall,
                  ),
                  Text(
                    "transactions.count".t(context, count ?? 0),
                    style: context.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
