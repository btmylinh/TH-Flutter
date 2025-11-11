import 'package:equatable/equatable.dart';

class Restaurant extends Equatable {
  final String id;
  final String name;
  final String description;
  final String address;
  final String imageUrl;
  final double averageRating;
  final int reviewCount;
  final List<String> categories;

  const Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.imageUrl,
    required this.averageRating,
    required this.reviewCount,
    required this.categories,
  });

  @override
  List<Object> get props => [
    id,
    name,
    description,
    address,
    imageUrl,
    averageRating,
    reviewCount,
    categories,
  ];
}
