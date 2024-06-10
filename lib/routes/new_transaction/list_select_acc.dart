import 'package:financeOFF/entity/account.dart';
import 'package:financeOFF/l10n/extension.dart';
import 'package:financeOFF/widgets/general/button.dart';
import 'package:financeOFF/widgets/general/fin_icon.dart';
import 'package:financeOFF/widgets/general/list_modal.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Появляется с [Account]
class SelectAccountSheet extends StatelessWidget {
  final List<Account> accounts;
  final int? currentlySelectedAccountId;

  final String? titleOverride;

  const SelectAccountSheet({
    super.key,
    required this.accounts,
    this.currentlySelectedAccountId,
    this.titleOverride,
  });

  @override
  Widget build(BuildContext context) {
    return ListModal.scrollable(
      title: Text(titleOverride ?? "transaction.edit.selectAccount".t(context)),
      scrollableContentMaxHeight: MediaQuery.of(context).size.height * .5,
      trailing: accounts.isEmpty
          ? ButtonBar(
              children: [
                Button(
                  onTap: () => context.pop(false),
                  child: Text(
                    "general.cancel".t(context),
                  ),
                ),
              ],
            )
          : null,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (accounts.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  "transaction.edit.selectAccount.noPossibleChoice".t(context),
                  textAlign: TextAlign.center,
                ),
              ),
            ...accounts.map(
              (account) => ListTile(
                title: Text(account.name),
                leading: FinIcon(account.icon),
                trailing: const Icon(Symbols.chevron_right_rounded),
                onTap: () => context.pop(account),
                selected: currentlySelectedAccountId == account.id,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
