import 'package:equatable/equatable.dart';

class TransactionEntity extends Equatable {
  final String? id;
  final String userId;
  final double amount;
  final String description;
  final String category;
  final DateTime date;
  final DateTime createdAt;

  const TransactionEntity({
    this.id,
    required this.userId,
    required this.amount,
    required this.description,
    required this.category,
    required this.date,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    amount,
    description,
    category,
    date,
    createdAt,
  ];
}
