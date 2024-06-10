import 'package:financeOFF/data/financeoff_icon.dart';
import 'package:financeOFF/l10n/extension.dart';
import 'package:financeOFF/widgets/general/fin_icon.dart';
import 'package:financeOFF/widgets/general/area.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

class AddCategoryCard extends StatelessWidget {
  final VoidCallback? onTapOverride;

  const AddCategoryCard({
    super.key,
    this.onTapOverride,
  });

  static BorderRadius borderRadius = BorderRadius.circular(16.0);

  @override
  Widget build(BuildContext context) {
    return Area(
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      builder: (context) => InkWell(
        borderRadius: borderRadius,
        onTap: onTapOverride ?? (() => context.push("/category/new")),
        child: Row(
          children: [
            FinIcon(
              FinIconData.icon(Symbols.add_rounded),
              size: 32.0,
              plated: true,
            ),
            const SizedBox(width: 12.0),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("category.new".t(context)),
              ],
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
