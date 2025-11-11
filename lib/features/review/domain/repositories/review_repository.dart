import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/review.dart';

abstract class ReviewRepository {
  Future<Either<Failure, void>> addReview(Review review, List<File> images);
  Future<Either<Failure, List<Review>>> getReviews(String restaurantId);
  Future<Either<Failure, String>> uploadImage(File image);
}
