import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/restaurant.dart';

abstract class RestaurantRepository {
  Future<Either<Failure, List<Restaurant>>> getRestaurants();
  Future<Either<Failure, Restaurant>> getRestaurantDetail(String id);
  Future<Either<Failure, String>> addRestaurant(Map<String, dynamic> data);
}
