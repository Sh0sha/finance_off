import 'package:financeOFF/entity/transaction.dart';
import 'package:financeOFF/utils/jsonable.dart';

abstract class TransactionExtension implements Jasonable {
  String get key;

  const TransactionExtension();
}

abstract class TransactionDataExtension extends TransactionExtension {
  final Transaction transaction;

  const TransactionDataExtension(this.transaction) : super();
}
