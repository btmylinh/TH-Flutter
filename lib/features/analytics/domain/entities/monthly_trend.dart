import 'package:equatable/equatable.dart';

class MonthlyTrend extends Equatable {
  final DateTime month;
  final double totalAmount;
  final int transactionCount;

  const MonthlyTrend({
    required this.month,
    required this.totalAmount,
    required this.transactionCount,
  });

  @override
  List<Object> get props => [month, totalAmount, transactionCount];
}
