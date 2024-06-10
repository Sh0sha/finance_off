import 'package:financeOFF/data/financeoff_icon.dart';
import 'package:financeOFF/entity/_base.dart';
import 'package:financeOFF/entity/transaction.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:objectbox/objectbox.dart';
import 'package:uuid/uuid.dart';

part "category.g.dart";

@Entity()
@JsonSerializable()
class Category implements EntityBase {
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

  @Backlink('category')
  @JsonKey(includeFromJson: false, includeToJson: false)
  final transactions = ToMany<Transaction>();

  String iconCode;

  @Transient()
  FinIconData get icon {
    try {
      return FinIconData.parse(iconCode);
    } catch (e) {
      return FinIconData.icon(Symbols.category_rounded);
    }
  }

  Category({
    this.id = 0,
    required this.name,
    required this.iconCode,
    DateTime? createdDate,
  })  : createdDate = createdDate ?? DateTime.now(),
        uuid = const Uuid().v4();

  Category.preset({
    required this.name,
    required this.iconCode,
    required this.uuid,
  })  : createdDate = DateTime.now(),
        id = -1;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
