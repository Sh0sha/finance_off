import 'package:financeOFF/data/money_finOFF.dart';



class FinoffAnalytics<T> {
  final DateTime from;
  final DateTime to;

  final Map<String, MoneyFin<T>> flow;

  const FinoffAnalytics({
    required this.from,
    required this.to,
    required this.flow,
  });
}
