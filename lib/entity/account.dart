import 'package:financeOFF/data/financeoff_icon.dart';
import 'package:financeOFF/entity/_base.dart';
import 'package:financeOFF/entity/transaction.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:objectbox/objectbox.dart';
import 'package:uuid/uuid.dart';

part "account.g.dart";

@Entity()
@JsonSerializable()
class Account implements EntityBase {
  @JsonKey(includeFromJson: false, includeToJson: false)
  int id;

  @override
  @Unique()
  String uuid;

  @Property(type: PropertyType.date)
  DateTime createdDate;

  static const int maxNameLength = 48;

  @Unique()
  String name;


  String currency;

  int sortOrder;

  @Backlink('account')
  @JsonKey(includeFromJson: false, includeToJson: false)
  final transactions = ToMany<Transaction>();

  String iconCode;

  bool excludeFromTotalBalance;

  @Transient()
  @JsonKey(includeFromJson: false, includeToJson: false)
  FinIconData get icon {
    try {
      return FinIconData.parse(iconCode);
    } catch (e) {
      return FinIconData.icon(Symbols.wallet_rounded);
    }
  }

  /// Возвращает текущий баланс. Это рассчитывается путем суммирования каждой отдельной транзакции
  ///
  ///
  @Transient()
  @JsonKey(includeFromJson: false, includeToJson: false)
  double get balance {
    return transactions
        .where((element) => element.transactionDate.isPast)
        .fold<double>(
          0,
          (previousValue, element) => previousValue + element.amount,
        );
  }

  Account({
    this.id = 0,
    required this.name,
    required this.currency,
    required this.iconCode,
    this.excludeFromTotalBalance = false,
    this.sortOrder = -1,
    DateTime? createdDate,
  })  : createdDate = createdDate ?? DateTime.now(),
        uuid = const Uuid().v4();

  Account.preset({
    required this.name,
    required this.currency,
    required this.iconCode,
    required this.uuid,
  })  : excludeFromTotalBalance = false,
        sortOrder = -1,
        id = -1,
        createdDate = DateTime.now();

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);
  Map<String, dynamic> toJson() => _$AccountToJson(this);
}
