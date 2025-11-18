import 'package:equatable/equatable.dart';

abstract class RestaurantEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadRestaurants extends RestaurantEvent {}

class RefreshRestaurants extends RestaurantEvent {}

class CreateRestaurant extends RestaurantEvent {
  final String name;
  final String description;
  final String address;
  final String category;
  final String imageUrl;

  CreateRestaurant({
    required this.name,
    required this.description,
    required this.address,
    required this.category,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [name, description, address, category, imageUrl];
}

class DeleteRestaurant extends RestaurantEvent {
  final String restaurantId;

  DeleteRestaurant({required this.restaurantId});

  @override
  List<Object?> get props => [restaurantId];
}
