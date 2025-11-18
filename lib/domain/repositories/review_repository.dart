import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/review_entity.dart';

abstract class ReviewRepository {
  Stream<Either<Failure, List<ReviewEntity>>> getReviewsByRestaurant(
    String restaurantId,
  );
  Future<Either<Failure, void>> addReview({
    required String restaurantId,
    required double rating,
    required String comment,
    required List<File> images,
  });
  Future<Either<Failure, void>> deleteReview(String reviewId);
}
