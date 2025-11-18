import 'package:equatable/equatable.dart';

class RestaurantEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final String address;
  final String category;
  final String imageUrl;
  final double averageRating;
  final int reviewCount;
  final DateTime createdAt;

  const RestaurantEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.category,
    required this.imageUrl,
    required this.averageRating,
    required this.reviewCount,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    address,
    category,
    imageUrl,
    averageRating,
    reviewCount,
    createdAt,
  ];
}
