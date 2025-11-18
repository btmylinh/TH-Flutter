import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/repositories/review_repository.dart';
import '../datasources/review_remote_data_source.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource remoteDataSource;

  ReviewRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<Either<Failure, List<ReviewEntity>>> getReviewsByRestaurant(
    String restaurantId,
  ) {
    return remoteDataSource
        .getReviewsByRestaurant(restaurantId)
        .map<Either<Failure, List<ReviewEntity>>>((reviews) {
          return Right(reviews);
        })
        .handleError((error) {
          return Left(ServerFailure(error.toString()));
        });
  }

  @override
  Future<Either<Failure, void>> addReview({
    required String restaurantId,
    required double rating,
    required String comment,
    required List<File> images,
  }) async {
    try {
      await remoteDataSource.addReview(
        restaurantId: restaurantId,
        rating: rating,
        comment: comment,
        images: images,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteReview(String reviewId) async {
    try {
      await remoteDataSource.deleteReview(reviewId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
