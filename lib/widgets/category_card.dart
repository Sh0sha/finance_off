import 'package:financeOFF/entity/category.dart';
import 'package:financeOFF/l10n/extension.dart';
import 'package:financeOFF/objectbox/actions.dart';
import 'package:financeOFF/theme/theme.dart';
import 'package:financeOFF/utils/value_or.dart';
import 'package:financeOFF/widgets/general/fin_icon.dart';
import 'package:financeOFF/widgets/general/area.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CategoryCard extends StatelessWidget {
  final Category category;

  final BorderRadius borderRadius;

  final bool showAmount;

  final ValueOr<VoidCallback>? onTapOverride;

  final Widget? trailing;

  const CategoryCard({
    super.key,
    required this.category,
    this.onTapOverride,
    this.trailing,
    this.showAmount = true,
    this.borderRadius = const BorderRadius.all(Radius.circular(16.0)),
  });

  @override
  Widget build(BuildContext context) {
    return Area(
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      builder: (context) => InkWell(
        borderRadius: borderRadius,
        onTap: onTapOverride == null
            ? () => context.push("/category/${category.id}")
            : onTapOverride!.value,
        child: Row(
          children: [
            FinIcon(
              category.icon,
              size: 32.0,
              plated: true,
            ),
            const SizedBox(width: 12.0),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: context.textTheme.titleSmall,
                ),
                if (showAmount)
                  Text(
                    category.transactions.sum.money,
                    style: context.textTheme.bodyMedium?.semi(context),
                  ),
              ],
            ),
            const Spacer(),
            if (trailing != null) ...[
              trailing!,
              const SizedBox(width: 12.0),
            ],
          ],
        ),
      ),
    );
  }
}
