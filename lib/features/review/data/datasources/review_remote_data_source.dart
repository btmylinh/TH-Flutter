import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/services/cloudinary_service.dart';
import '../models/review_model.dart';

abstract class ReviewRemoteDataSource {
  Future<void> addReview(ReviewModel review, List<String> imageUrls);
  Future<List<ReviewModel>> getReviews(String restaurantId);
  Future<String> uploadImage(File image);
}

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  final FirebaseFirestore firestore;

  ReviewRemoteDataSourceImpl({required this.firestore});

  @override
  Future<void> addReview(ReviewModel review, List<String> imageUrls) async {
    try {
      final reviewData = review.toJson();
      reviewData['imageUrls'] = imageUrls;

      // Add review to Firestore
      await firestore.collection('reviews').add(reviewData);

      // Update restaurant rating (hỗ trợ cả 2 dạng field)
      final restaurantRef = firestore
          .collection('restaurants')
          .doc(review.restaurantId);
      final restaurantDoc = await restaurantRef.get();

      if (restaurantDoc.exists) {
        final data = restaurantDoc.data()!;
        final currentRating = (data['rating'] ?? data['averageRating'] ?? 0.0)
            .toDouble();
        final reviewCount =
            (data['totalReviews'] ?? data['reviewCount'] ?? 0) as int;

        final newReviewCount = reviewCount + 1;
        final newAverageRating =
            ((currentRating * reviewCount) + review.rating) / newReviewCount;

        await restaurantRef.update({
          'rating': newAverageRating,
          'totalReviews': newReviewCount,
          // Ghi đồng thời 2 cặp field để tương thích
          'averageRating': newAverageRating,
          'reviewCount': newReviewCount,
        });
      }
    } catch (e) {
      throw Exception('Failed to add review: ${e.toString()}');
    }
  }

  @override
  Future<List<ReviewModel>> getReviews(String restaurantId) async {
    try {
      final snapshot = await firestore
          .collection('reviews')
          .where('restaurantId', isEqualTo: restaurantId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return ReviewModel.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception('Failed to get reviews: ${e.toString()}');
    }
  }

  @override
  Future<String> uploadImage(File image) async {
    try {
      // Sử dụng Cloudinary thay vì Firebase Storage
      final imageUrl = await CloudinaryService.uploadImage(image);
      return imageUrl;
    } catch (e) {
      throw Exception('Failed to upload image: ${e.toString()}');
    }
  }
}
