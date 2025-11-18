import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/category_stats.dart';
import '../repositories/analytics_repository.dart';

class GetCategoryStats implements UseCase<List<CategoryStats>, NoParams> {
  final AnalyticsRepository repository;

  GetCategoryStats(this.repository);

  @override
  Future<Either<Failure, List<CategoryStats>>> call(NoParams params) async {
    return await repository.getCategoryStats();
  }
}
