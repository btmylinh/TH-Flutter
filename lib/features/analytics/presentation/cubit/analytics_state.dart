import 'package:equatable/equatable.dart';
import '../../domain/entities/category_stats.dart';
import '../../domain/entities/monthly_trend.dart';

abstract class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object?> get props => [];
}

class AnalyticsInitial extends AnalyticsState {}

class AnalyticsLoading extends AnalyticsState {}

class AnalyticsLoaded extends AnalyticsState {
  final List<CategoryStats> categoryStats;
  final List<MonthlyTrend> monthlyTrends;

  const AnalyticsLoaded({
    required this.categoryStats,
    required this.monthlyTrends,
  });

  @override
  List<Object> get props => [categoryStats, monthlyTrends];
}

class AnalyticsError extends AnalyticsState {
  final String message;

  const AnalyticsError(this.message);

  @override
  List<Object> get props => [message];
}
