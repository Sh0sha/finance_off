import 'package:financeOFF/data/financeoff_icon.dart';
import 'package:financeOFF/l10n/extension.dart';
import 'package:financeOFF/theme/theme.dart';
import 'package:financeOFF/widgets/general/fin_icon.dart';
import 'package:financeOFF/widgets/general/area.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

class AddAccountCard extends StatelessWidget {
  final BorderRadius borderRadius;

  const AddAccountCard({
    super.key,
    this.borderRadius = const BorderRadius.all(Radius.circular(24.0)),
  });

  @override
  Widget build(BuildContext context) {
    return Area(
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      builder: (context) => InkWell(
        onTap: () => context.push("/account/new"),
        borderRadius: borderRadius,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  FinIcon(
                    FinIconData.icon(Symbols.add_rounded),
                    size: 60.0,
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    "setup.accounts.addAccount".t(context),
                    style: context.textTheme.titleSmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
