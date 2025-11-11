import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_restaurants.dart';
import '../../domain/usecases/get_restaurant_detail.dart';
import '../../domain/usecases/add_restaurant.dart';
import 'restaurant_event.dart';
import 'restaurant_state.dart';

class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  final GetRestaurants getRestaurants;
  final GetRestaurantDetail getRestaurantDetail;
  final AddRestaurant addRestaurant;

  RestaurantBloc({
    required this.getRestaurants,
    required this.getRestaurantDetail,
    required this.addRestaurant,
  }) : super(RestaurantInitial()) {
    on<GetRestaurantsEvent>(_onGetRestaurants);
    on<GetRestaurantDetailEvent>(_onGetRestaurantDetail);
    on<AddRestaurantEvent>(_onAddRestaurant);
  }

  Future<void> _onGetRestaurants(
    GetRestaurantsEvent event,
    Emitter<RestaurantState> emit,
  ) async {
    emit(RestaurantLoading());
    final result = await getRestaurants(NoParams());
    result.fold(
      (failure) => emit(RestaurantError(failure.message)),
      (restaurants) => emit(RestaurantListLoaded(restaurants)),
    );
  }

  Future<void> _onGetRestaurantDetail(
    GetRestaurantDetailEvent event,
    Emitter<RestaurantState> emit,
  ) async {
    emit(RestaurantLoading());
    final result = await getRestaurantDetail(event.id);
    result.fold(
      (failure) => emit(RestaurantError(failure.message)),
      (restaurant) => emit(RestaurantDetailLoaded(restaurant)),
    );
  }

  Future<void> _onAddRestaurant(
    AddRestaurantEvent event,
    Emitter<RestaurantState> emit,
  ) async {
    emit(RestaurantLoading());
    final params = {
      'name': event.name,
      'address': event.address,
      'imageUrl': event.imageUrl,
      'cuisine': event.cuisine,
      'rating': event.rating,
      'totalReviews': event.totalReviews,
      'description': event.description,
      'categories': [event.cuisine],
    };

    final result = await addRestaurant(params);
    result.fold(
      (failure) => emit(RestaurantError(failure.message)),
      (id) => emit(RestaurantAdded(id)),
    );
  }
}
