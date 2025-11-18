import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/monthly_trend.dart';
import '../repositories/analytics_repository.dart';

class GetMonthlyTrend
    implements UseCase<List<MonthlyTrend>, GetMonthlyTrendParams> {
  final AnalyticsRepository repository;

  GetMonthlyTrend(this.repository);

  @override
  Future<Either<Failure, List<MonthlyTrend>>> call(
    GetMonthlyTrendParams params,
  ) async {
    return await repository.getMonthlyTrend(params.months);
  }
}

class GetMonthlyTrendParams extends Equatable {
  final int months;

  const GetMonthlyTrendParams({required this.months});

  @override
  List<Object> get props => [months];
}
