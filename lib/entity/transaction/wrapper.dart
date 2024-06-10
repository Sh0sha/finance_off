import 'dart:convert';
import 'dart:developer';

import 'package:financeOFF/entity/transaction/extensions/base.dart';
import 'package:financeOFF/entity/transaction/extensions/default/transfer.dart';
import 'package:financeOFF/utils/utils.dart';

class ExtensionsWrapper {
  Transfer? get transfer =>
      data.firstWhereOrNull((element) => element is Transfer) as Transfer?;

  final List<TransactionExtension> data;

  const ExtensionsWrapper(this.data);
  const ExtensionsWrapper.empty() : data = const [];

  /// Returns a new instance with merged
  ExtensionsWrapper merge(List<TransactionExtension> newData) {
    return ExtensionsWrapper([
      ...data.where(
          (currrent) => !newData.any((newExt) => currrent.key == newExt.key)),
      ...newData,
    ]);
  }

  static ExtensionsWrapper parse(String? extra) {
    if (extra == null) return const ExtensionsWrapper.empty();

    try {
      return ExtensionsWrapper((jsonDecode(extra) as List<dynamic>)
          .map((item) => deserialize(item as Map<String, dynamic>))
          .nonNulls
          .toList());
    } catch (e) {
      log("[ExtensionsWrapper] An error occured during deserializing: $e");
      return const ExtensionsWrapper.empty();
    }
  }

  List<Map<String, dynamic>> toJson() {
    return data.map((e) => e.toJson()).toList();
  }

  String? serialize() {
    if (data.isEmpty) return null;

    try {
      return jsonEncode(toJson());
    } catch (e) {
      return null;
    }
  }

  static T? deserialize<T extends TransactionExtension>(
      Map<String, dynamic> value) {
    return switch (value["key"]) {
      Transfer.keyName => Transfer.fromJson(value) as T,
      _ => null,
    };
  }
}
