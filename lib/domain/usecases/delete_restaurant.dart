import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../repositories/restaurant_repository.dart';

class DeleteRestaurant implements UseCase<void, DeleteRestaurantParams> {
  final RestaurantRepository repository;

  DeleteRestaurant(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteRestaurantParams params) async {
    return await repository.deleteRestaurant(params.restaurantId);
  }
}

class DeleteRestaurantParams {
  final String restaurantId;

  DeleteRestaurantParams({required this.restaurantId});
}
