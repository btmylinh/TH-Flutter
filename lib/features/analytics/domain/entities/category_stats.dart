import 'package:equatable/equatable.dart';

class CategoryStats extends Equatable {
  final String category;
  final double totalAmount;
  final int transactionCount;
  final double percentage;

  const CategoryStats({
    required this.category,
    required this.totalAmount,
    required this.transactionCount,
    required this.percentage,
  });

  @override
  List<Object> get props => [
    category,
    totalAmount,
    transactionCount,
    percentage,
  ];
}
