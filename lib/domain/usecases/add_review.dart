import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../repositories/review_repository.dart';

class AddReviewParams {
  final String restaurantId;
  final double rating;
  final String comment;
  final List<File> images;

  AddReviewParams({
    required this.restaurantId,
    required this.rating,
    required this.comment,
    required this.images,
  });
}

class AddReview extends UseCase<void, AddReviewParams> {
  final ReviewRepository repository;

  AddReview(this.repository);

  @override
  Future<Either<Failure, void>> call(AddReviewParams params) async {
    return await repository.addReview(
      restaurantId: params.restaurantId,
      rating: params.rating,
      comment: params.comment,
      images: params.images,
    );
  }
}
