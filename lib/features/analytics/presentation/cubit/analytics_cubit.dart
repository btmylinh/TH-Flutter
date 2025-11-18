import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_category_stats.dart';
import '../../domain/usecases/get_monthly_trend.dart';
import 'analytics_state.dart';

class AnalyticsCubit extends Cubit<AnalyticsState> {
  final GetCategoryStats getCategoryStats;
  final GetMonthlyTrend getMonthlyTrend;

  AnalyticsCubit({
    required this.getCategoryStats,
    required this.getMonthlyTrend,
  }) : super(AnalyticsInitial());

  Future<void> loadAnalytics({int months = 6}) async {
    emit(AnalyticsLoading());

    final categoryStatsResult = await getCategoryStats(NoParams());
    final monthlyTrendResult = await getMonthlyTrend(
      GetMonthlyTrendParams(months: months),
    );

    categoryStatsResult.fold(
      (failure) => emit(AnalyticsError(failure.message)),
      (categoryStats) {
        monthlyTrendResult.fold(
          (failure) => emit(AnalyticsError(failure.message)),
          (monthlyTrends) => emit(
            AnalyticsLoaded(
              categoryStats: categoryStats,
              monthlyTrends: monthlyTrends,
            ),
          ),
        );
      },
    );
  }
}
