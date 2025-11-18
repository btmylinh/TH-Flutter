import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  final String id;
  final String restaurantId;
  final String userId;
  final String userName;
  final String? userPhotoUrl;
  final double rating;
  final String comment;
  final List<String> imageUrls;
  final DateTime createdAt;

  const ReviewEntity({
    required this.id,
    required this.restaurantId,
    required this.userId,
    required this.userName,
    this.userPhotoUrl,
    required this.rating,
    required this.comment,
    required this.imageUrls,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    restaurantId,
    userId,
    userName,
    userPhotoUrl,
    rating,
    comment,
    imageUrls,
    createdAt,
  ];
}
