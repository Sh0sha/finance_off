import 'package:auto_size_text/auto_size_text.dart';
import 'package:financeOFF/entity/transaction.dart';
import 'package:financeOFF/l10n/extension.dart';
import 'package:financeOFF/theme/theme.dart';
import 'package:financeOFF/widgets/general/area.dart';
import 'package:flutter/material.dart';

class FlowCard extends StatelessWidget {
  final TransactionType type;
  final double flow;

  const FlowCard({super.key, required this.flow, required this.type});

  @override
  Widget build(BuildContext context) {
    return Area(builder: (context) {
      return Container(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).textScaler.scale(
              context.textTheme.displaySmall!.height! *
                      context.textTheme.displaySmall!.fontSize! +
                  24.0),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        child: AutoSizeText(
          flow.abs().money,
          style: context.textTheme.displaySmall?.copyWith(
            color: type.color(context),
          ),
          minFontSize: 10.0,
          maxLines: 1,
        ),
      );
    });
  }
}
