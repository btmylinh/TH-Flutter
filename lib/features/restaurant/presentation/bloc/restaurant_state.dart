import 'package:equatable/equatable.dart';
import '../../domain/entities/restaurant.dart';

abstract class RestaurantState extends Equatable {
  const RestaurantState();

  @override
  List<Object> get props => [];
}

class RestaurantInitial extends RestaurantState {}

class RestaurantLoading extends RestaurantState {}

class RestaurantListLoaded extends RestaurantState {
  final List<Restaurant> restaurants;

  const RestaurantListLoaded(this.restaurants);

  @override
  List<Object> get props => [restaurants];
}

class RestaurantDetailLoaded extends RestaurantState {
  final Restaurant restaurant;

  const RestaurantDetailLoaded(this.restaurant);

  @override
  List<Object> get props => [restaurant];
}

class RestaurantError extends RestaurantState {
  final String message;

  const RestaurantError(this.message);

  @override
  List<Object> get props => [message];
}

class RestaurantAdded extends RestaurantState {
  final String id;
  const RestaurantAdded(this.id);

  @override
  List<Object> get props => [id];
}
