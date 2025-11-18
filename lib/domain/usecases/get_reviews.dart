import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/review_entity.dart';
import '../repositories/review_repository.dart';

class GetReviewsParams {
  final String restaurantId;

  GetReviewsParams({required this.restaurantId});
}

class GetReviews extends StreamUseCase<List<ReviewEntity>, GetReviewsParams> {
  final ReviewRepository repository;

  GetReviews(this.repository);

  @override
  Stream<Either<Failure, List<ReviewEntity>>> call(GetReviewsParams params) {
    return repository.getReviewsByRestaurant(params.restaurantId);
  }
}
