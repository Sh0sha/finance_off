import 'dart:io';

import 'package:financeOFF/entity/account.dart';
import 'package:financeOFF/l10n/finance_localisation.dart';
import 'package:financeOFF/objectbox.dart';
import 'package:financeOFF/objectbox/actions.dart';
import 'package:financeOFF/objectbox/objectbox.g.dart';
import 'package:financeOFF/prefs.dart';
import 'package:financeOFF/theme/theme.dart';
import 'package:financeOFF/utils/utils.dart';
import 'package:financeOFF/utils/value_or.dart';
import 'package:financeOFF/widgets/account_card.dart';
import 'package:financeOFF/widgets/account_card_skeleton.dart';
import 'package:financeOFF/widgets/general/spinner.dart';
import 'package:financeOFF/widgets/home/home/account/no_accounts.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

class AccountsTab extends StatefulWidget {
  const AccountsTab({super.key});

  @override
  State<AccountsTab> createState() => _AccountsTabState();
}

class _AccountsTabState extends State<AccountsTab>
    with AutomaticKeepAliveClientMixin {
  bool _reordering = false;

  QueryBuilder<Account> qb() =>
      ObjectBox().box<Account>().query().order(Account_.sortOrder);

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return ValueListenableBuilder(
        valueListenable: ObjectBox().invalidateAccounts,
        builder: (context, snapshot, child) {
          return StreamBuilder<List<Account>>(
              stream: qb()
                  .watch(triggerImmediately: true)
                  .map((event) => event.find()),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Spinner.center();
                }

                final List<Account> accounts = snapshot.requireData;

                return switch (accounts.length) {
                  0 => const NoAccounts(),
                  _ => Column(
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.all(16.0).copyWith(bottom: 0.0),
                          child: buildHeader(context),
                        ),
                        ValueListenableBuilder(
                            valueListenable: LocalPreferences()
                                .excludeTransferFromFlow
                                .valueNotifier,
                            builder: (context, excludeTransfersInTotal, child) {
                              return Expanded(
                                child: _reordering
                                    ? ReorderableListView.builder(
                                        padding: const EdgeInsets.all(16.0)
                                            .copyWith(bottom: 96.0),
                                        itemBuilder: (context, index) =>
                                            Padding(
                                          key: ValueKey(accounts[index].uuid),
                                          padding: const EdgeInsets.only(
                                              bottom: 16.0),
                                          child: AccountCard(
                                            account: accounts[index],
                                            useCupertinoContextMenu: false,
                                            excludeTransfersInTotal:
                                                excludeTransfersInTotal == true,
                                          ),
                                        ),
                                        proxyDecorator: proxyDecorator,
                                        itemCount: accounts.length,
                                        onReorder: (oldIndex, newIndex) =>
                                            onReorder(
                                                accounts, oldIndex, newIndex),
                                      )
                                    : ListView(
                                        padding: const EdgeInsets.all(16.0),
                                        children: [
                                          ...accounts.map(
                                            (account) => Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 16.0),
                                              child: AccountCard(
                                                account: account,
                                                useCupertinoContextMenu:
                                                    Platform.isIOS,
                                                excludeTransfersInTotal:
                                                    excludeTransfersInTotal ==
                                                        true,
                                                onTapOverride:
                                                    ValueOr(() async {
                                                  await context.push(
                                                      "/account/${account.id}");
                                                  setState(() {});
                                                }),
                                              ),
                                            ),
                                          ),
                                          AccountCardSkeleton(
                                            onTap: () =>
                                                context.push("/account/new"),
                                          ),
                                          const SizedBox(height: 16.0),
                                          const SizedBox(height: 64.0),
                                        ],
                                      ),
                              );
                            }),
                      ],
                    ),
                };
              });
        });
  }

  Widget buildHeader(BuildContext context) {
    return Row(
      children: [
        Text(
          (_reordering && !isDesktop())
              ? "tabs.accounts.reorder.guide".t(context)
              : "tabs.accounts".t(context),
          style: context.textTheme.titleSmall,
        ),
        const Spacer(),
        IconButton(
          onPressed: toggleReorderMode,
          tooltip: _reordering
              ? "general.done".t(context)
              : "tabs.accounts.reorder".t(context),
          icon: _reordering
              ? const Icon(Symbols.check_rounded)
              : const Icon(Symbols.reorder_rounded),
        ),
      ],
    );
  }

  Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        return Material(
          elevation: 0,
          color: Colors.transparent,
          child: child,
        );
      },
      child: child,
    );
  }

  void toggleReorderMode() {
    setState(() {
      _reordering = !_reordering;
    });
  }

  void onReorder(List<Account> currentAccounts, int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final removed = currentAccounts.removeAt(oldIndex);
    currentAccounts.insert(newIndex, removed);

    ObjectBox().updateAccountOrderList(accounts: currentAccounts);
  }

  @override
  bool get wantKeepAlive => true;
}
