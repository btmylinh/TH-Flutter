import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../transaction/domain/entities/transaction_entity.dart';
import '../../../transaction/domain/repositories/transaction_repository.dart';
import '../../domain/entities/category_stats.dart';
import '../../domain/entities/monthly_trend.dart';
import '../../domain/repositories/analytics_repository.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  final TransactionRepository transactionRepository;

  AnalyticsRepositoryImpl({required this.transactionRepository});

  @override
  Future<Either<Failure, List<CategoryStats>>> getCategoryStats() async {
    try {
      final transactions = await transactionRepository
          .getTransactions()
          .first
          .then(
            (either) => either.fold(
              (failure) => throw Exception(failure.message),
              (transactions) => transactions,
            ),
          );

      if (transactions.isEmpty) {
        return const Right([]);
      }

      final totalAmount = transactions.fold<double>(
        0,
        (sum, transaction) => sum + transaction.amount,
      );

      final categoryMap = <String, List<TransactionEntity>>{};
      for (var transaction in transactions) {
        categoryMap.putIfAbsent(transaction.category, () => []);
        categoryMap[transaction.category]!.add(transaction);
      }

      final stats = categoryMap.entries.map((entry) {
        final categoryTotal = entry.value.fold<double>(
          0,
          (sum, transaction) => sum + transaction.amount,
        );
        return CategoryStats(
          category: entry.key,
          totalAmount: categoryTotal,
          transactionCount: entry.value.length,
          percentage: (categoryTotal / totalAmount) * 100,
        );
      }).toList();

      stats.sort((a, b) => b.totalAmount.compareTo(a.totalAmount));

      return Right(stats);
    } catch (e) {
      return Left(ServerFailure('Lỗi khi phân tích dữ liệu: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<MonthlyTrend>>> getMonthlyTrend(
    int months,
  ) async {
    try {
      final transactions = await transactionRepository
          .getTransactions()
          .first
          .then(
            (either) => either.fold(
              (failure) => throw Exception(failure.message),
              (transactions) => transactions,
            ),
          );

      if (transactions.isEmpty) {
        return const Right([]);
      }

      final now = DateTime.now();
      final monthsData = <DateTime, List<TransactionEntity>>{};

      for (var i = 0; i < months; i++) {
        final month = DateTime(now.year, now.month - i, 1);
        monthsData[month] = [];
      }

      for (var transaction in transactions) {
        final transactionMonth = DateTime(
          transaction.date.year,
          transaction.date.month,
          1,
        );
        if (monthsData.containsKey(transactionMonth)) {
          monthsData[transactionMonth]!.add(transaction);
        }
      }

      final trends = monthsData.entries.map((entry) {
        final total = entry.value.fold<double>(
          0,
          (sum, transaction) => sum + transaction.amount,
        );
        return MonthlyTrend(
          month: entry.key,
          totalAmount: total,
          transactionCount: entry.value.length,
        );
      }).toList();

      trends.sort((a, b) => a.month.compareTo(b.month));

      return Right(trends);
    } catch (e) {
      return Left(ServerFailure('Lỗi khi phân tích xu hướng: ${e.toString()}'));
    }
  }
}
