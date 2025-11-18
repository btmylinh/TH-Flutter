import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/usecases/usecase.dart';
import '../../../domain/usecases/get_restaurants.dart';
import '../../../domain/usecases/create_restaurant.dart' as usecases;
import '../../../domain/usecases/delete_restaurant.dart' as delete_usecases;
import 'restaurant_event.dart';
import 'restaurant_state.dart';

class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  final GetRestaurants getRestaurants;
  final usecases.CreateRestaurant createRestaurantUseCase;
  final delete_usecases.DeleteRestaurant deleteRestaurantUseCase;
  StreamSubscription? _restaurantSubscription;

  RestaurantBloc({
    required this.getRestaurants,
    required this.createRestaurantUseCase,
    required this.deleteRestaurantUseCase,
  }) : super(RestaurantInitial()) {
    on<LoadRestaurants>(_onLoadRestaurants);
    on<RefreshRestaurants>(_onRefreshRestaurants);
    on<CreateRestaurant>(_onCreateRestaurant);
    on<DeleteRestaurant>(_onDeleteRestaurant);
  }

  Future<void> _onLoadRestaurants(
    LoadRestaurants event,
    Emitter<RestaurantState> emit,
  ) async {
    print('📡 [RestaurantBloc] LoadRestaurants được gọi');
    emit(RestaurantLoading());
    await _restaurantSubscription?.cancel();

    await emit.forEach(
      getRestaurants(NoParams()),
      onData: (result) {
        print('📡 [RestaurantBloc] Nhận stream restaurants...');
        return result.fold(
          (failure) {
            print(
              '❌ [RestaurantBloc] Lỗi khi lấy danh sách nhà hàng: ${failure.message}',
            );
            return RestaurantError(message: failure.message);
          },
          (restaurants) {
            print(
              '✅ [RestaurantBloc] Nhận được ${restaurants.length} nhà hàng',
            );
            return RestaurantLoaded(restaurants: restaurants);
          },
        );
      },
    );
  }

  Future<void> _onRefreshRestaurants(
    RefreshRestaurants event,
    Emitter<RestaurantState> emit,
  ) async {
    // For refresh, we don't show loading state
    await _restaurantSubscription?.cancel();

    await emit.forEach(
      getRestaurants(NoParams()),
      onData: (result) {
        return result.fold(
          (failure) => RestaurantError(message: failure.message),
          (restaurants) => RestaurantLoaded(restaurants: restaurants),
        );
      },
    );
  }

  Future<void> _onCreateRestaurant(
    CreateRestaurant event,
    Emitter<RestaurantState> emit,
  ) async {
    emit(RestaurantCreating());
    final result = await createRestaurantUseCase(
      usecases.CreateRestaurantParams(
        name: event.name,
        description: event.description,
        address: event.address,
        category: event.category,
        imageUrl: event.imageUrl,
      ),
    );
    if (!emit.isDone) {
      result.fold(
        (failure) => emit(RestaurantError(message: failure.message)),
        (_) => emit(RestaurantCreateSuccess()),
      );
    }
  }

  Future<void> _onDeleteRestaurant(
    DeleteRestaurant event,
    Emitter<RestaurantState> emit,
  ) async {
    // Không emit RestaurantDeleting để giữ nguyên UI
    // Chỉ thực hiện xóa, Firestore stream sẽ tự động cập nhật danh sách
    final result = await deleteRestaurantUseCase(
      delete_usecases.DeleteRestaurantParams(
        restaurantId: event.restaurantId,
      ),
    );
    
    // Nếu có lỗi thì mới emit error, thành công thì không làm gì
    // vì stream sẽ tự động cập nhật
    if (!emit.isDone) {
      result.fold(
        (failure) => emit(RestaurantError(message: failure.message)),
        (_) {
          // Không emit RestaurantDeleteSuccess
          // Stream từ Firestore sẽ tự động cập nhật danh sách
        },
      );
    }
  }

  @override
  Future<void> close() {
    _restaurantSubscription?.cancel();
    return super.close();
  }
}
