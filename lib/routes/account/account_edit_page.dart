import 'dart:developer';

import 'package:financeOFF/data/financeoff_icon.dart';
import 'package:financeOFF/entity/account.dart';
import 'package:financeOFF/entity/transaction.dart';
import 'package:financeOFF/form_validators.dart';
import 'package:financeOFF/l10n/extension.dart';
import 'package:financeOFF/objectbox.dart';
import 'package:financeOFF/objectbox/actions.dart';
import 'package:financeOFF/objectbox/objectbox.g.dart';
import 'package:financeOFF/prefs.dart';
import 'package:financeOFF/routes/new_transaction/list_amount_input.dart';
import 'package:financeOFF/theme/theme.dart';
import 'package:financeOFF/utils/utils.dart';
import 'package:financeOFF/widgets/delete_button.dart';
import 'package:financeOFF/widgets/general/fin_icon.dart';
import 'package:financeOFF/widgets/select_valyuta_list.dart';
import 'package:financeOFF/widgets/select_fin_icon_list.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

class AccountEditPage extends StatefulWidget {
  /// Аккаунт объекта айди
  final int accountId;

  bool get isNewAccount => accountId == 0;

  const AccountEditPage({super.key, required this.accountId});
  const AccountEditPage.create({
    super.key,
  }) : accountId = 0;

  @override
  State<AccountEditPage> createState() => _AccountEditPageState();
}

class _AccountEditPageState extends State<AccountEditPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  late final TextEditingController _nameTextController;

  final FocusNode _editNameFocusNode = FocusNode();

  late String _currency;
  late FinIconData? _iconData;
  late bool _excludeFromTotalBalance;

  late double _balance;

  late final Account? _currentlyEditing;

  bool _editingName = false;

  String get iconCodeOrError =>
      _iconData?.toString() ??
      FinIconData.icon(Symbols.wallet_rounded).toString();

  dynamic error;

  @override
  void initState() {
    super.initState();

    _currentlyEditing = widget.isNewAccount
        ? null
        : ObjectBox().box<Account>().get(widget.accountId);

    if (!widget.isNewAccount && _currentlyEditing == null) {
      error = "Аккаунт с идентификатором ${widget.accountId} не найден.";
    } else {
      _nameTextController =
          TextEditingController(text: _currentlyEditing?.name);
      _balance = _currentlyEditing?.balance ?? 0.0;
      _currency = _currentlyEditing?.currency ??
          LocalPreferences().getPrimaryCurrency();
      _iconData = _currentlyEditing?.icon;
      _excludeFromTotalBalance =
          _currentlyEditing?.excludeFromTotalBalance ?? false;
    }

    _editNameFocusNode.addListener(() {
      if (!_editNameFocusNode.hasFocus) {
        toggleEditName(false);
      }
    });
  }

  @override
  void dispose() {
    _editNameFocusNode.dispose();
    _nameTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const contentPadding = EdgeInsets.symmetric(horizontal: 16.0);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => save(),
            icon: const Icon(Symbols.check_rounded),
            tooltip: "general.save".t(context),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 16.0),
                Padding(
                  padding: contentPadding,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FinIcon(
                            _iconData ??
                                FinIconData.icon(Symbols.wallet_rounded),
                            size: 64.0,
                            plated: true,
                            onTap: selectIcon,
                          ),
                          TextButton(
                            onPressed: selectIcon,
                            child: Text(
                              "flowIcon.change".t(context),
                              style: context.textTheme.labelSmall?.copyWith(
                                color: context.colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _nameTextController,
                                    focusNode: _editNameFocusNode,
                                    maxLength: Account.maxNameLength,
                                    decoration: InputDecoration(
                                      hintText: "account.name".t(context),
                                      focusColor: context.colorScheme.secondary,
                                      isDense: true,
                                      border: _editingName
                                          ? null
                                          : InputBorder.none,
                                      counter: const SizedBox.shrink(),
                                    ),
                                    onTap: () => toggleEditName(true),
                                    onFieldSubmitted: (_) =>
                                        toggleEditName(false),
                                    readOnly: !_editingName,
                                    validator: validateNameField,
                                  ),
                                ),
                                const SizedBox(width: 12.0),
                                IconButton(
                                  icon: _editingName
                                      ? const Icon(Symbols.done_rounded)
                                      : const Icon(Symbols.edit_rounded),
                                  onPressed: toggleEditName,
                                )
                              ],
                            ),
                            if (!widget.isNewAccount)
                              Text(
                                _currency,
                                style:
                                    context.textTheme.labelLarge?.semi(context),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24.0),
                InkWell(
                  borderRadius: BorderRadius.circular(16.0),
                  onTap: updateBalance,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: contentPadding,
                          child: Text(
                            _balance.formatMoney(currency: _currency),
                            style: context.textTheme.displayMedium,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        Text(
                          "account.updateBalance".t(context),
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
                CheckboxListTile.adaptive(
                  value: _excludeFromTotalBalance,
                  onChanged: updateBalanceExclusion,
                  title: Text("account.excludeFromTotalBalance".t(context)),
                  activeColor: context.colorScheme.primary,
                ),
                if (widget.isNewAccount)
                  ListTile(
                    title: Text("currency".t(context)),
                    trailing: Text(
                      _currency,
                      style: context.textTheme.labelLarge,
                    ),
                    onTap: selectCurrency,
                  ),
                if (_currentlyEditing != null) ...[
                  const SizedBox(height: 80.0),
                  DeleteButton(
                    onTap: _deleteAccount,
                    label: Text("account.delete".t(context)),
                  ),
                  const SizedBox(height: 16.0),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateBalance() async {
    final result = await showModalBottomSheet<double>(
      context: context,
      builder: (context) => InputAmountSheet(
        initialAmount: _balance,
        currency: _currency,
      ),
      isScrollControlled: true,
    );

    setState(() {
      _balance = result ?? _balance;
    });
  }

  void updateBalanceExclusion(bool? value) {
    if (value != null) {
      setState(() {
        _excludeFromTotalBalance = value;
      });
    }
  }

  void selectCurrency() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => const SelectValyutaList(),
      isScrollControlled: true,
    );

    setState(() {
      _currency = result ?? _currency;
    });
  }

  void update({required String formattedName}) async {
    if (_currentlyEditing == null) return;

    _currentlyEditing.name = formattedName;
    _currentlyEditing.currency = _currency;

    _currentlyEditing.iconCode = iconCodeOrError;
    _currentlyEditing.excludeFromTotalBalance = _excludeFromTotalBalance;

    if (_balance != _currentlyEditing.balance) {
      _currentlyEditing.updateBalanceAndSave(
        _balance,
        title: "account.updateBalance.transactionTitle".tr(),
      );
    }

    ObjectBox().box<Account>().put(
          _currentlyEditing,
          mode: PutMode.update,
        );

    if (mounted) {
      context.pop();
    }
  }

  void save() async {
    if (_formKey.currentState?.validate() != true) return;

    final String trimmed = _nameTextController.text.trim();

    if (_currentlyEditing != null) {
      return update(formattedName: trimmed);
    }

    final int sortOrder = ObjectBox().box<Account>().count();

    final account = Account(
      name: trimmed,
      iconCode: iconCodeOrError,
      currency: _currency,
      excludeFromTotalBalance: _excludeFromTotalBalance,
      sortOrder: sortOrder,
    );

    if (_balance.abs() != 0) {
      ObjectBox()
          .box<Account>()
          .putAndGetAsync(
            account,
            mode: PutMode.insert,
          )
          .then((value) {
        value.updateBalanceAndSave(
          _balance,
          title: "account.updateBalance.transactionTitle".tr(),
        );
        ObjectBox().box<Account>().putAsync(value);
      });
    } else {
      ObjectBox().box<Account>().putAsync(
            account,
            mode: PutMode.insert,
          );
    }

    context.pop();
  }

  void toggleEditName([bool? force]) {
    setState(() {
      _editingName = force ?? !_editingName;
    });

    if (_editingName) {
      _editNameFocusNode.requestFocus();
    }
  }

  String? validateNameField(String? value) {
    final requiredValidationError = checkReqPole(value);
    if (requiredValidationError != null) {
      return requiredValidationError.t(context);
    }

    final String trimmed = value!.trim();

    final Query<Account> sameNameQuery = ObjectBox()
        .box<Account>()
        .query(
          Account_.name
              .equals(trimmed)
              .and(Account_.id.notEquals(_currentlyEditing?.id ?? 0)),
        )
        .build();

    final bool isNameUnique = sameNameQuery.count() == 0;

    sameNameQuery.close();

    if (!isNameUnique) {
      return "error.input.duplicate.accountName".t(context, trimmed);
    }

    return null;
  }

  void _updateIcon(FinIconData? data) {
    _iconData = data;
  }

  Future<void> selectIcon() async {
    final result = await showModalBottomSheet<FinIconData>(
      context: context,
      builder: (context) => SelectFlowIconSheet(
        current: _iconData,
      ),
      isScrollControlled: true,
    );

    if (result != null) {
      _updateIcon(result);
    }

    if (mounted) setState(() {});
  }

  void _deleteAccount() async {
    if (_currentlyEditing == null) return;

    final Query<Transaction> associatedTransactionsQuery = ObjectBox()
        .box<Transaction>()
        .query(Transaction_.account.equals(_currentlyEditing.id))
        .build();

    final int txnCount = associatedTransactionsQuery.count();

    final bool? confirmation = await context.showConfirmDialog(
      isDeletionConfirmation: true,
      title: "general.delete.confirmName".t(context, _currentlyEditing.name),
      child: Text("account.delete.warning".t(context, txnCount)),
    );

    if (confirmation == true) {

      try {
        await associatedTransactionsQuery.removeAsync();
      } catch (e) {
        log("[Account Page] Не удалось удалить связанные транзакции для аккаунта.${_currentlyEditing.name} (${_currentlyEditing.uuid}) из-за :\n$e");
      } finally {
        associatedTransactionsQuery.close();
      }

      try {
        await ObjectBox().box<Account>().removeAsync(_currentlyEditing.id);
      } catch (e) {
        log("[Account Page]Не удалось удалить учетную запись ${_currentlyEditing.name} (${_currentlyEditing.uuid}) из-за:\n$e");
      } finally {
        if (mounted) {
          context.pop();
        }
      }
    }
  }
}
