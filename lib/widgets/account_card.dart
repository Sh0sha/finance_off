import 'package:financeOFF/entity/account.dart';
import 'package:financeOFF/l10n/extension.dart';
import 'package:financeOFF/objectbox/actions.dart';
import 'package:financeOFF/theme/theme.dart';
import 'package:financeOFF/utils/value_or.dart';
import 'package:financeOFF/widgets/general/fin_icon.dart';
import 'package:financeOFF/widgets/general/area.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AccountCard extends StatelessWidget {
  final Account account;

  final ValueOr<VoidCallback>? onTapOverride;

  final bool useCupertinoContextMenu;

  final bool excludeTransfersInTotal;

  final BorderRadius borderRadius;

  const AccountCard({
    super.key,
    required this.account,
    required this.useCupertinoContextMenu,
    this.onTapOverride,
    this.borderRadius = const BorderRadius.all(Radius.circular(24.0)),
    required this.excludeTransfersInTotal,
  });

  @override
  Widget build(BuildContext context) {
    final double dohodSum = excludeTransfersInTotal
        ? account.transactions.nonTransfers.incomeSum
        : account.transactions.incomeSum;
    final double rashodSum = excludeTransfersInTotal
        ? account.transactions.nonTransfers.expenseSum
        : account.transactions.expenseSum;

    final child = Area(
      shape: RoundedRectangleBorder(borderRadius: borderRadius),
      builder: (context) => InkWell(
        onTap: onTapOverride == null
            ? () => context.push("/account/${account.id}")
            : onTapOverride!.value,
        borderRadius: borderRadius,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  FinIcon(
                    account.icon,
                    size: 65.0,
                  ),
                  const SizedBox(width: 25.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        account.name,
                        style: context.textTheme.titleLarge,
                      ),
                      Text(
                        account.balance.formatMoney(currency: account.currency),
                        style: context.textTheme.displaySmall,
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 24.0),
              Text("Этот месяц", style: context.textTheme.bodyLarge),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Доход",
                      style: context.textTheme.labelSmall?.semi(context),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Расход",
                      style: context.textTheme.labelSmall?.semi(context),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      dohodSum.formatMoney(
                        currency: account.currency,
                      ),
                      style: context.textTheme.bodyLarge,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      rashodSum.formatMoney(
                        currency: account.currency,
                      ),
                      style: context.textTheme.bodyLarge,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (!useCupertinoContextMenu) return child;

    return CupertinoContextMenu.builder(
      builder: (context, animation) {
        return Padding(
          padding: const EdgeInsets.all(16.0) * animation.value,
          child: child,
        );
      },
      actions: [
        // TODO Почему он все еще открыт? Мне действительно нужно нажать, а затем нажать?
        CupertinoContextMenuAction(
          onPressed: () => context.push("/account/${account.id}"),
          isDefaultAction: true,
          trailingIcon: CupertinoIcons.pencil,
          child: Text("account.edit".t(context)),
        ),
        CupertinoContextMenuAction(
          onPressed: () => context.push(
              "/account/${account.id}/transactions?title=${"account.transactions.title".t(context, account.name)}"),
          isDefaultAction: true,
          trailingIcon: CupertinoIcons.square_list,
          child: Text("account.transactions".t(context)),
        ),
      ],
    );
  }
}
