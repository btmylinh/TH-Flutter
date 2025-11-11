import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/review.dart';
import '../repositories/review_repository.dart';

class AddReview implements UseCase<void, AddReviewParams> {
  final ReviewRepository repository;

  AddReview(this.repository);

  @override
  Future<Either<Failure, void>> call(AddReviewParams params) async {
    return await repository.addReview(params.review, params.images);
  }
}

class AddReviewParams {
  final Review review;
  final List<File> images;

  AddReviewParams({required this.review, required this.images});
}
