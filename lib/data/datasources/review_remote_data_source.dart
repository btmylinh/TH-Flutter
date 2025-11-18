import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/services/cloudinary_service.dart';
import '../models/review_model.dart';

abstract class ReviewRemoteDataSource {
  Stream<List<ReviewModel>> getReviewsByRestaurant(String restaurantId);
  Future<void> addReview({
    required String restaurantId,
    required double rating,
    required String comment,
    required List<File> images,
  });
  Future<void> deleteReview(String reviewId);
}

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  final FirebaseFirestore firestore;
  final CloudinaryService cloudinaryService;
  final FirebaseAuth firebaseAuth;

  ReviewRemoteDataSourceImpl({
    required this.firestore,
    required this.cloudinaryService,
    required this.firebaseAuth,
  });

  @override
  Stream<List<ReviewModel>> getReviewsByRestaurant(String restaurantId) {
    return firestore
        .collection('reviews')
        .where('restaurantId', isEqualTo: restaurantId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          final docs = snapshot.docs;
          print(
            '📥 [ReviewRemoteDataSource] getReviewsByRestaurant($restaurantId) snapshot: ${docs.length} documents',
          );
          for (final doc in docs) {
            print('  🔹 reviewId=${doc.id}, data=${doc.data()}');
          }
          return docs
              .map((doc) => ReviewModel.fromJson(doc.data(), doc.id))
              .toList();
        });
  }

  @override
  Future<void> addReview({
    required String restaurantId,
    required double rating,
    required String comment,
    required List<File> images,
  }) async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Get user data
      final userDoc = await firestore.collection('users').doc(user.uid).get();
      final userData = userDoc.data();

      // Upload images to Cloudinary
      final imageUrls = await cloudinaryService.uploadMultipleImages(
        images,
        'reviews',
      );

      // Create review
      final review = ReviewModel(
        id: '', // Will be set by Firestore
        restaurantId: restaurantId,
        userId: user.uid,
        userName: userData?['displayName'] ?? 'Anonymous',
        userPhotoUrl: userData?['photoUrl'],
        rating: rating,
        comment: comment,
        imageUrls: imageUrls,
        createdAt: DateTime.now(),
      );

      await firestore.collection('reviews').add(review.toJson());
    } catch (e) {
      throw Exception('Add review failed: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteReview(String reviewId) async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Get review to check ownership
      final reviewDoc = await firestore
          .collection('reviews')
          .doc(reviewId)
          .get();
      if (!reviewDoc.exists) {
        throw Exception('Review not found');
      }

      final reviewData = reviewDoc.data()!;
      if (reviewData['userId'] != user.uid) {
        throw Exception('Not authorized to delete this review');
      }

      // Note: Cloudinary images can be managed through their dashboard or API
      // For this implementation, we'll just delete the Firestore document
      // In production, you may want to delete Cloudinary images using their API

      // Delete review from Firestore
      await firestore.collection('reviews').doc(reviewId).delete();
    } catch (e) {
      throw Exception('Delete review failed: ${e.toString()}');
    }
  }
}
