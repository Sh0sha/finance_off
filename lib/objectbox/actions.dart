import 'dart:developer';
import 'dart:math' as math;

import 'package:financeOFF/data/financeoff_analytic.dart';
import 'package:financeOFF/data/memo.dart';
import 'package:financeOFF/data/money_finOFF.dart';
import 'package:financeOFF/data/prefs/frecency_group.dart';
import 'package:financeOFF/entity/account.dart';
import 'package:financeOFF/entity/category.dart';
import 'package:financeOFF/entity/transaction.dart';
import 'package:financeOFF/entity/transaction/extensions/base.dart';
import 'package:financeOFF/entity/transaction/extensions/default/transfer.dart';
import 'package:financeOFF/l10n/extension.dart';
import 'package:financeOFF/objectbox.dart';
import 'package:financeOFF/objectbox/objectbox.g.dart';
import 'package:financeOFF/prefs.dart';
import 'package:financeOFF/utils/utils.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:uuid/uuid.dart';

typedef RelevanceScoredTitle = ({String title, double relevancy});

extension MainActions on ObjectBox {
  double getTotalBalance() {
    final Query<Account> accountsQuery = box<Account>()
        .query(Account_.excludeFromTotalBalance.equals(false))
        .build();

    final List<Account> accounts = accountsQuery.find();

    return accounts
        .map((e) => e.balance)
        .fold(0, (previousValue, element) => previousValue + element);
  }

  List<Account> getAccounts([bool sortByFrecency = true]) {
    final List<Account> accounts = box<Account>().getAll();

    if (sortByFrecency) {
      final FrecencyGroup frecencyGroup = FrecencyGroup(accounts
          .map((account) =>
              LocalPreferences().getFrecencyData("account", account.uuid))
          .nonNulls
          .toList());

      accounts.sort((a, b) => frecencyGroup
          .getScore(b.uuid)
          .compareTo(frecencyGroup.getScore(a.uuid)));
    }

    return accounts;
  }

  List<Category> getCategory([bool sortByFrecency = true]) {
    final List<Category> categories = box<Category>().getAll();

    if (sortByFrecency) {
      final FrecencyGroup frecencyGroup = FrecencyGroup(categories
          .map((category) =>
              LocalPreferences().getFrecencyData("category", category.uuid))
          .nonNulls
          .toList());

      categories.sort((a, b) => frecencyGroup
          .getScore(b.uuid)
          .compareTo(frecencyGroup.getScore(a.uuid)));
    }

    return categories;
  }

  Future<void> updateAccountOrderList({
    List<Account>? accounts,
    bool ignoreIfNoUnsetValue = false,
  }) async {
    accounts ??= await ObjectBox().box<Account>().getAllAsync();

    if (ignoreIfNoUnsetValue &&
        !accounts.any((element) => element.sortOrder < 0)) {
      return;
    }

    for (final e in accounts.indexed) {
      accounts[e.$1].sortOrder = e.$1;
    }

    await ObjectBox().box<Account>().putManyAsync(accounts);
  }

  /// Returns a map of category uuid -> [MoneyFin]
  Future<FinoffAnalytics<Category>> flowByCategories({
    required DateTime from,
    required DateTime to,
    bool ignoreTransfers = true,
    bool omitZeroes = true,
  }) async {
    final Condition<Transaction> dateFilter =
        Transaction_.transactionDate.betweenDate(from, to);

    final Query<Transaction> transactionsQuery =
        ObjectBox().box<Transaction>().query(dateFilter).build();

    final List<Transaction> transactions = await transactionsQuery.findAsync();

    transactionsQuery.close();

    final Map<String, MoneyFin<Category>> flow = {};

    for (final transaction in transactions) {
      if (ignoreTransfers && transaction.isTransfer) continue;

      final String categoryUuid =
          transaction.category.target?.uuid ?? Uuid.NAMESPACE_NIL;

      flow[categoryUuid] ??=
          MoneyFin(associatedData: transaction.category.target);
      flow[categoryUuid]!.add(transaction.amount);
    }

    if (omitZeroes) {
      flow.removeWhere((key, value) => value.isEmpty);
    }

    return FinoffAnalytics(flow: flow, from: from, to: to);
  }

  /// Returns a map of category uuid -> [MoneyFin]
  Future<FinoffAnalytics<Account>> flowByAccounts({
    required DateTime from,
    required DateTime to,
    bool ignoreTransfers = true,
    bool omitZeroes = true,
  }) async {
    final Condition<Transaction> dateFilter =
        Transaction_.transactionDate.betweenDate(from, to);

    final Query<Transaction> transactionsQuery =
        ObjectBox().box<Transaction>().query(dateFilter).build();

    final List<Transaction> transactions = await transactionsQuery.findAsync();

    transactionsQuery.close();

    final Map<String, MoneyFin<Account>> flow = {};

    for (final transaction in transactions) {
      if (ignoreTransfers && transaction.isTransfer) continue;

      final String accountUuid =
          transaction.account.target?.uuid ?? Uuid.NAMESPACE_NIL;

      flow[accountUuid] ??=
          MoneyFin(associatedData: transaction.account.target);
      flow[accountUuid]!.add(transaction.amount);
    }

    assert(!flow.containsKey(Uuid.NAMESPACE_NIL),
        "There is no way you've managed to make a transaction without an account");

    if (omitZeroes) {
      flow.removeWhere((key, value) => value.isEmpty);
    }

    return FinoffAnalytics(from: from, to: to, flow: flow);
  }

  Future<List<RelevanceScoredTitle>> transactionTitleSuggestions({
    String? currentInput,
    int? accountId,
    int? categoryId,
    TransactionType? type,
    int? limit,
  }) async {
    final Query<Transaction> transactionsQuery = ObjectBox()
        .box<Transaction>()
        .query(Transaction_.title.contains(
          currentInput?.trim() ?? "",
          caseSensitive: false,
        ))
        .build();

    final List<Transaction> transactions = await transactionsQuery
        .findAsync()
        .then((value) => value.where((element) {
              if (element.title?.trim().isNotEmpty != true) {
                return false;
              }
              if (type != TransactionType.transfer && element.isTransfer) {
                return false;
              }

              return true;
            }).toList())
        .catchError(
      (error) {
        log("Не удалось получить транзакции для предложенных заголовков.: $error");
        return <Transaction>[];
      },
    );

    transactionsQuery.close();

    final List<RelevanceScoredTitle> relevanceCalculatedList = transactions
        .map((e) => (
              title: e.title,
              relevancy: e.titleSuggestionScore(
                accountId: accountId,
                categoryId: categoryId,
                transactionType: type,
              )
            ))
        .cast<RelevanceScoredTitle>()
        .toList();

    relevanceCalculatedList.sort((a, b) => b.relevancy.compareTo(a.relevancy));

    final List<RelevanceScoredTitle> scoredTitles =
        _mergeTitleRelevancy(relevanceCalculatedList);

    scoredTitles.sort((a, b) => b.relevancy.compareTo(a.relevancy));

    return scoredTitles.sublist(
      0,
      limit == null ? null : math.min(limit, scoredTitles.length),
    );
  }

  /// Удаляет дубликаты из итерируемого объекта на основе функции keyExtractor.
  List<RelevanceScoredTitle> _mergeTitleRelevancy(
    List<RelevanceScoredTitle> scores,
  ) {
    final List<List<RelevanceScoredTitle>> grouped =
        scores.groupBy((relevance) => relevance.title).values.toList();

    return grouped.map(
      (items) {
        final double sum = items
            .map((x) => x.relevancy)
            .fold<double>(0, (value, element) => value + element);

        final double average = sum / items.length;

        ///Если элемент встречается несколько раз, его релевантность увеличивается.
        final double weight = 1 + (items.length * 0.025);

        return (
          title: items.first.title,
          relevancy: average * weight,
        );
      },
    ).toList();
  }
}

extension TransactionActions on Transaction {
  double titleSuggestionScore({
    String? query,
    int? accountId,
    int? categoryId,
    TransactionType? transactionType,
  }) {
    late double score;

    if (query == null ||
        query.trim().isEmpty ||
        title == null ||
        title!.trim().isEmpty) {
      score = 10.0; // Full match score is 100
    } else {
      score = partialRatio(query, title!).toDouble() + 10.0;
    }

    double multipler = 1.0;

    if (account.targetId == accountId) {
      multipler += 0.25;
    }

    if (transactionType != null && transactionType == type) {
      multipler += 0.75;
    }

    if (category.targetId == categoryId) {
      multipler += 2.75;
    }

    return score * multipler;
  }

  /// Когда пользователь осуществляет перевод, он фактически создает две транзакции.
  //  ///
  //  /// 1. Основной (сумма положительная)
  //  /// 2. Счётчик один (сумма отрицательна)
  //  ///
  //  /// При редактировании передачи все должно применяться к обоим
  //  /// транзакции для согласованности
  Transaction? findTransferOriginalOrThis() {
    if (!isTransfer) return this;

    final Transfer transfer = extensions.transfer!;

    if (amount.isNegative) return this;

    final Query<Transaction> query = ObjectBox()
        .box<Transaction>()
        .query(Transaction_.uuid.equals(transfer.relatedTransactionUuid))
        .build();

    try {
      return query.findFirst();
    } catch (e) {
      return this;
    } finally {
      query.close();
    }
  }

  bool delete() {
    if (isTransfer) {
      final Transfer? transfer = extensions.transfer;

      if (transfer == null) {
        log("Не удалось правильно удалить транзакцию перевода из-за отсутствия данных о переводе");
      } else {
        final Query<Transaction> relatedTransactionQuery = ObjectBox()
            .box<Transaction>()
            .query(Transaction_.uuid.equals(transfer.relatedTransactionUuid))
            .build();

        final Transaction? relatedTransaction =
            relatedTransactionQuery.findFirst();

        relatedTransactionQuery.close();

        try {
          final bool removedRelated = ObjectBox()
              .box<Transaction>()
              .remove(relatedTransaction?.id ?? -1);

          if (!removedRelated) {
            throw Exception("Не удалось удалить связанную транзакцию.");
          }
        } catch (e) {
          log("Не удалось правильно удалить транзакцию перевода из-за: $e");
        }
      }
    }

    return ObjectBox().box<Transaction>().remove(id);
  }
}

extension TransactionListActions on Iterable<Transaction> {
  Iterable<Transaction> get nonTransfers =>
      where((transaction) => !transaction.isTransfer);
  Iterable<Transaction> get transfers =>
      where((transaction) => transaction.isTransfer);
  Iterable<Transaction> get expenses =>
      where((transaction) => transaction.amount.isNegative);
  Iterable<Transaction> get incomes =>
      where((transaction) => transaction.amount > 0);

  /// Количество транзакций, отображаемых на экране
  //  ///
  //  /// Это зависит от [LocalPreferences().combineTransferTransactions]
  //  /// и текущий список транзакций
  int get renderableCount =>
      length -
      (LocalPreferences().combineTransferTransactions.get()
          ? transfers.length ~/ 2
          : 0);

  double get incomeSum =>
      incomes.fold(0, (value, element) => value + element.amount);
  double get expenseSum =>
      expenses.fold(0, (value, element) => value + element.amount);
  double get sum => fold(0, (value, element) => value + element.amount);

  MoneyFin get flow => MoneyFin(
        totalExpense: expenseSum,
        totalIncome: incomeSum,
      );

  /// Если для параметра [mergeFutureTransactions] установлено значение true, транзакции в будущем
  /// относительно [anchor] будут сгруппированы в одну группу
  Map<TimeRange, List<Transaction>> groupByDate({
    DateTime? anchor,
  }) =>
      groupByRange(
        rangeFn: (transaction) => DayTimeRange.fromDateTime(
          transaction.transactionDate,
        ),
        anchor: anchor,
      );

  Map<TimeRange, List<Transaction>> groupByRange({
    DateTime? anchor,
    required TimeRange Function(Transaction) rangeFn,
  }) {
    anchor ??= DateTime.now();

    final Map<TimeRange, List<Transaction>> value = {};

    for (final transaction in this) {
      final TimeRange range = rangeFn(transaction);

      value[range] ??= [];
      value[range]!.add(transaction);
    }

    return value;
  }
}

extension AccountActions on Account {
  static Memoizer<String, String?>? accountNameToUuid;

  static String nameByUuid(String uuid) {
    accountNameToUuid ??= Memoizer(
      compute: _nameByUuid,
    );

    return accountNameToUuid!.get(uuid) ?? "???";
  }

  static String _nameByUuid(String uuid) {
    final query =
        ObjectBox().box<Account>().query(Account_.uuid.equals(uuid)).build();

    try {
      return query.findFirst()?.name ?? "???";
    } catch (e) {
      return "???";
    } finally {
      query.close();
    }
  }

  /// Создает новую транзакцию и сохраняет ее
  //  ///
  //  /// Возвращает идентификатор транзакции из[Box.put]
  int updateBalanceAndSave(
    double targetBalance, {
    String? title,
    DateTime? transactionDate,
  }) {
    final double delta = targetBalance - balance;

    return createAndSaveTransaction(
      amount: delta,
      title: title,
      transactionDate: transactionDate,
    );
  }

  /// Возвращает идентификаторы объектов из `box.put`
  //  ///
  //  /// Первая транзакция представляет собой списание денег с [этого] счета
  //  ///
  //  /// Вторая транзакция представляет собой поступление денег на целевой счет
  (int from, int to) transferTo({
    String? title,
    required Account targetAccount,
    required double amount,
    DateTime? createdDate,
    DateTime? transactionDate,
  }) {
    if (amount <= 0) {
      return targetAccount.transferTo(
        targetAccount: this,
        amount: amount.abs(),
        title: title,
        createdDate: createdDate,
        transactionDate: transactionDate,
      );
    }

    final String fromTransactionUuid = const Uuid().v4();
    final String toTransactionUuid = const Uuid().v4();

    final Transfer transferData = Transfer(
      uuid: const Uuid().v4(),
      fromAccountUuid: uuid,
      toAccountUuid: targetAccount.uuid,
      relatedTransactionUuid: toTransactionUuid,
    );

    final String resolvedTitle = title ??
        "transaction.transfer.fromToTitle"
            .tr({"from": name, "to": targetAccount.name});

    final int fromTransaction = createAndSaveTransaction(
      amount: -amount,
      title: resolvedTitle,
      extensions: [transferData],
      uuidOverride: fromTransactionUuid,
      createdDate: createdDate,
      transactionDate: transactionDate,
    );
    final int toTransaction = targetAccount.createAndSaveTransaction(
      amount: amount,
      title: resolvedTitle,
      extensions: [
        transferData.copyWith(relatedTransactionUuid: fromTransactionUuid)
      ],
      uuidOverride: toTransactionUuid,
      createdDate: createdDate,
      transactionDate: transactionDate,
    );

    return (fromTransaction, toTransaction);
  }

  /// Returns transaction id from [Box.put]
  int createAndSaveTransaction({
    required double amount,
    DateTime? transactionDate,
    DateTime? createdDate,
    String? title,
    Category? category,
    List<TransactionExtension>? extensions,
    String? uuidOverride,
  }) {
    Transaction value = Transaction(
      amount: amount,
      valuyta: currency,
      title: title,
      transactionDate: transactionDate,
      createdDate: createdDate,
      uuidOverride: uuidOverride,
    )
      ..setCategory(category)
      ..setAccount(this);

    if (extensions != null && extensions.isNotEmpty) {
      value.addExtensions(extensions);
    }

    final int id = ObjectBox().box<Transaction>().put(value);

    try {
      LocalPreferences().updateFrecencyData("account", uuid);
      if (category != null) {
        LocalPreferences().updateFrecencyData("category", category.uuid);
      }
    } catch (e) {
      log("Не удалось обновить данные о частоте транзакции. ($id)");
    }

    return id;
  }
}

