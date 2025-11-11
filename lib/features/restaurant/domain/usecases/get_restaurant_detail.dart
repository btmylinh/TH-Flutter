import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/restaurant.dart';
import '../repositories/restaurant_repository.dart';

class GetRestaurantDetail implements UseCase<Restaurant, String> {
  final RestaurantRepository repository;

  GetRestaurantDetail(this.repository);

  @override
  Future<Either<Failure, Restaurant>> call(String id) async {
    return await repository.getRestaurantDetail(id);
  }
}
