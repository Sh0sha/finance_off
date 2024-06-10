import 'package:financeOFF/entity/transaction.dart';
import 'package:financeOFF/l10n/finance_localisation.dart';
import 'package:financeOFF/routes/preferences/transfer_preferences/demo_transaction_list_tile.dart';
import 'package:financeOFF/theme/theme.dart';
import 'package:flutter/material.dart';

class CombineTransferRadio extends StatelessWidget {
  final VoidCallback onTap;

  final bool combine;

  final bool currentlyUsingCombineMode;

  final BorderRadius borderRadius;

  const CombineTransferRadio.combine({
    super.key,
    required this.currentlyUsingCombineMode,
    required this.onTap,
    this.borderRadius = const BorderRadius.all(Radius.circular(16.0)),
  }) : combine = true;
  const CombineTransferRadio.separate({
    super.key,
    required this.currentlyUsingCombineMode,
    required this.onTap,
    this.borderRadius = const BorderRadius.all(Radius.circular(16.0)),
  }) : combine = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: borderRadius,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            combine ? buildCombine(context) : buildSeparate(context),
            const SizedBox(height: 8.0),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(combine
                    ? "preferences.transfer.combineTransferTransaction.combine"
                        .t(context)
                    : "preferences.transfer.combineTransferTransaction.separate"
                        .t(context)),
                const SizedBox(height: 8.0),
                IgnorePointer(
                  child: Radio.adaptive(
                    value: combine,
                    groupValue: currentlyUsingCombineMode,
                    onChanged: (_) {},
                    activeColor: context.colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCombine(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
      child: DemoTransactionListTile(type: TransactionType.transfer),
    );
  }

  Widget buildSeparate(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const DemoTransactionListTile(type: TransactionType.dohod),
          Divider(
            height: 8.0,
            color: context.flowColors.semi.withAlpha(0x40),
          ),
          const DemoTransactionListTile(type: TransactionType.rashod),
        ],
      ),
    );
  }
}
