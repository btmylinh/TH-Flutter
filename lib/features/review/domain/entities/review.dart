import 'package:equatable/equatable.dart';

class Review extends Equatable {
  final String id;
  final String restaurantId;
  final String userId;
  final String userName;
  final String content;
  final double rating;
  final List<String> imageUrls;
  final DateTime createdAt;

  const Review({
    required this.id,
    required this.restaurantId,
    required this.userId,
    required this.userName,
    required this.content,
    required this.rating,
    required this.imageUrls,
    required this.createdAt,
  });

  @override
  List<Object> get props => [
    id,
    restaurantId,
    userId,
    userName,
    content,
    rating,
    imageUrls,
    createdAt,
  ];
}
