import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/category_stats.dart';
import '../entities/monthly_trend.dart';

abstract class AnalyticsRepository {
  Future<Either<Failure, List<CategoryStats>>> getCategoryStats();
  Future<Either<Failure, List<MonthlyTrend>>> getMonthlyTrend(int months);
}
