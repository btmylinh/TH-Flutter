import 'package:equatable/equatable.dart';

abstract class RestaurantEvent extends Equatable {
  const RestaurantEvent();

  @override
  List<Object> get props => [];
}

class GetRestaurantsEvent extends RestaurantEvent {}

class GetRestaurantDetailEvent extends RestaurantEvent {
  final String id;

  const GetRestaurantDetailEvent(this.id);

  @override
  List<Object> get props => [id];
}

class AddRestaurantEvent extends RestaurantEvent {
  final String name;
  final String address;
  final String imageUrl;
  final String cuisine;
  final double rating;
  final int totalReviews;
  final String description;

  const AddRestaurantEvent({
    required this.name,
    required this.address,
    required this.imageUrl,
    required this.cuisine,
    this.rating = 0.0,
    this.totalReviews = 0,
    this.description = '',
  });

  @override
  List<Object> get props => [
    name,
    address,
    imageUrl,
    cuisine,
    rating,
    totalReviews,
    description,
  ];
}
