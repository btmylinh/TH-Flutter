import '../../domain/entities/review.dart';

class ReviewModel extends Review {
  const ReviewModel({
    required super.id,
    required super.restaurantId,
    required super.userId,
    required super.userName,
    required super.content,
    required super.rating,
    required super.imageUrls,
    required super.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] ?? '',
      restaurantId: json['restaurantId'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      content: json['content'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurantId': restaurantId,
      'userId': userId,
      'userName': userName,
      'content': content,
      'rating': rating,
      'imageUrls': imageUrls,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
