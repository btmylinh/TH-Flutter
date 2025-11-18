import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/restaurant_entity.dart';

abstract class RestaurantRepository {
  Stream<Either<Failure, List<RestaurantEntity>>> getRestaurants();
  Future<Either<Failure, RestaurantEntity>> getRestaurantById(String id);
  Stream<Either<Failure, RestaurantEntity>> watchRestaurant(String id);
  Future<Either<Failure, void>> createRestaurant({
    required String name,
    required String description,
    required String address,
    required String category,
    required String imageUrl,
  });
  Future<Either<Failure, void>> deleteRestaurant(String id);
}
