import 'package:financeOFF/entity/category.dart';
import 'package:financeOFF/l10n/extension.dart';
import 'package:financeOFF/utils/value_or.dart';
import 'package:financeOFF/widgets/general/fin_icon.dart';
import 'package:financeOFF/widgets/general/list_modal.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

/// появляется с [ValueOr<Category>]
class SelectCategorySheet extends StatelessWidget {
  final List<Category> categories;
  final int? currentlySelectedCategoryId;

  const SelectCategorySheet({
    super.key,
    required this.categories,
    this.currentlySelectedCategoryId,
  });

  @override
  Widget build(BuildContext context) {
    return ListModal.scrollable(
      title: Text("transaction.edit.selectCategory".t(context)),
      trailing: ButtonBar(
        children: [
          TextButton.icon(
            onPressed: () => context.pop(const ValueOr<Category>(null)),
            icon: const Icon(Symbols.block_rounded),
            label: Text("category.skip".t(context)),
          ),
        ],
      ),
      scrollableContentMaxHeight: MediaQuery.of(context).size.height * 0.5,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...categories.map(
              (category) => ListTile(
                title: Text(category.name),
                leading: FinIcon(category.icon),
                trailing: const Icon(Symbols.chevron_right_rounded),
                onTap: () => context.pop(ValueOr(category)),
                selected: currentlySelectedCategoryId == category.id,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
