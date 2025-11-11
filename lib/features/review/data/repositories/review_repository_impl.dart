import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/review.dart';
import '../../domain/repositories/review_repository.dart';
import '../datasources/review_remote_data_source.dart';
import '../models/review_model.dart';

class ReviewRepositoryImpl implements ReviewRepository {
  final ReviewRemoteDataSource remoteDataSource;
  final FirebaseMessaging firebaseMessaging;

  ReviewRepositoryImpl({
    required this.remoteDataSource,
    required this.firebaseMessaging,
  });

  @override
  Future<Either<Failure, void>> addReview(
    Review review,
    List<File> images,
  ) async {
    try {
      // Upload images first
      List<String> imageUrls = [];
      for (var image in images) {
        final url = await remoteDataSource.uploadImage(image);
        imageUrls.add(url);
      }

      // Merge any URLs provided directly in the review with the uploaded ones
      final combinedUrls = [
        ...review.imageUrls,
        ...imageUrls,
      ];

      // Create review model
      final reviewModel = ReviewModel(
        id: review.id,
        restaurantId: review.restaurantId,
        userId: review.userId,
        userName: review.userName,
        content: review.content,
        rating: review.rating,
        imageUrls: combinedUrls,
        createdAt: review.createdAt,
      );

      // Add review
      await remoteDataSource.addReview(reviewModel, combinedUrls);

      // Send notification (optional - would need Cloud Functions for production)
      // This is a simplified version
      try {
        // In production, you'd send this through your backend/Cloud Functions
        print('New review added - notification would be sent here');
      } catch (e) {
        print('Failed to send notification: $e');
      }

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Review>>> getReviews(String restaurantId) async {
    try {
      final reviews = await remoteDataSource.getReviews(restaurantId);
      return Right(reviews);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> uploadImage(File image) async {
    try {
      final url = await remoteDataSource.uploadImage(image);
      return Right(url);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
