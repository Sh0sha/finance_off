import 'package:financeOFF/entity/_base.dart';
import 'package:financeOFF/entity/account.dart';
import 'package:financeOFF/entity/category.dart';
import 'package:financeOFF/entity/transaction/extensions/base.dart';
import 'package:financeOFF/entity/transaction/wrapper.dart';
import 'package:financeOFF/l10n/name_num.dart';
import 'package:financeOFF/utils/utils.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:objectbox/objectbox.dart';
import 'package:uuid/uuid.dart';

part "transaction.g.dart";

@Entity()
@JsonSerializable()
class Transaction implements EntityBase {
  @JsonKey(includeFromJson: false, includeToJson: false)
  int id;

  @override
  @Unique()
  String uuid;

  @Property(type: PropertyType.date)
  DateTime createdDate;

  @Property(type: PropertyType.date)
  DateTime transactionDate;

  static const int maxTitleLength = 256;

  String? title;

  double amount;


  String valuyta;

  // Позже нам может понадобиться ссылка на родительскую транзакцию, чтобы
  //   редактируем их как один. Это может быть полезно, например, при кредите/сбережениях с
  //   интерес. Опять же, показывая интерес и базу как два отдельных
  //  транзакции могут быть не очень хорошей идеей.
  //
  /// Подтип транзакции
  @Property()
  String? subtype;

  @Transient()
  @JsonKey(includeFromJson: false, includeToJson: false)
  TransactionSubtype? get transactionSubtype => subtype == null
      ? null
      : TransactionSubtype.values
          .where((element) => element.value == (subtype!))
          .firstOrNull;

  @Transient()
  set transactionSubtype(TransactionSubtype? value) {
    subtype = value?.value;
  }

  /// Дополнительная информация, связанная с транзакцией
  //
  //  Мы планируем использовать это поле как место для хранения данных для пользовательских расширений.
  //  например, мы можем использовать JSON и предоставить каждому расширению возможность редактировать свой «ключ»
  // в этом поле. (гарантируя отсутствие коллизий между расширениями)
  String? extra;

  @Transient()
  @JsonKey(includeFromJson: false, includeToJson: false)
  ExtensionsWrapper get extensions => ExtensionsWrapper.parse(extra);

  @Transient()
  set extensions(ExtensionsWrapper newValue) {
    extra = newValue.serialize();
  }

  void addExtensions(Iterable<TransactionExtension> newExtensions) {
    extensions = extensions.merge(newExtensions.toList());
  }

  @Transient()
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool get isTransfer => extensions.transfer != null;

  @Transient()
  @JsonKey(includeFromJson: false, includeToJson: false)
  TransactionType get type {
    if (isTransfer) return TransactionType.transfer;

    return amount.isNegative ? TransactionType.rashod : TransactionType.dohod;
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  final category = ToOne<Category>();

  @Transient()
  String? _categoryUuid;

  String? get categoryUuid => _categoryUuid ?? category.target?.uuid;

  set categoryUuid(String? value) {
    _categoryUuid = value;
  }

  /// Это не будет сохранено, пока вы не вызовете `Box.put()`
  void setCategory(Category? newCategory) {
    category.target = newCategory;
    categoryUuid = newCategory?.uuid;
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  final account = ToOne<Account>();

  @Transient()
  String? _accountUuid;

  String? get accountUuid => _accountUuid ?? account.target?.uuid;

  set accountUuid(String? value) {
    _accountUuid = value;
  }

  /// Это не будет сохранено, пока вы не вызовете `Box.put()`
  void setAccount(Account? newAccount) {


    if (valuyta != newAccount?.currency) {
      throw Exception("Невозможно ");
    }

    account.target = newAccount;
    accountUuid = newAccount?.uuid;
    valuyta = newAccount?.currency ?? valuyta;
  }

  Transaction({
    this.id = 0,
    this.title,
    this.subtype,
    required this.amount,
    required this.valuyta,
    DateTime? transactionDate,
    DateTime? createdDate,
    String? uuidOverride,
  })  : createdDate = createdDate ?? DateTime.now(),
        transactionDate = transactionDate ?? createdDate ?? DateTime.now(),
        uuid = uuidOverride ?? const Uuid().v4();

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}

@JsonEnum(valueField: "value")
enum TransactionType implements LocalizedEnum {
  transfer("передача"),
  dohod("доход"),
  rashod("расход");

  final String value;

  const TransactionType(this.value);

  @override
  String get localizationEnumValue => name;
  @override
  String get localizationEnumName => "TransactionType";

  static TransactionType? fromJson(Map json) {
    return TransactionType.values
        .firstWhereOrNull((element) => element.value == json["value"]);
  }

  Map<String, dynamic> toJson() => {"value": value};
}

@JsonEnum(valueField: "value")
enum TransactionSubtype implements LocalizedEnum {
  transactionFee("transactionFee"),
  givenLoan("loan.given"),
  receivedLoan("loan.received");

  final String value;

  const TransactionSubtype(this.value);

  @override
  String get localizationEnumValue => name;
  @override
  String get localizationEnumName => "TransactionSubtype";
}
