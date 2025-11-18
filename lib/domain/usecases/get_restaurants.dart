import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../entities/restaurant_entity.dart';
import '../repositories/restaurant_repository.dart';

class GetRestaurants extends StreamUseCase<List<RestaurantEntity>, NoParams> {
  final RestaurantRepository repository;

  GetRestaurants(this.repository);

  @override
  Stream<Either<Failure, List<RestaurantEntity>>> call(NoParams params) {
    return repository.getRestaurants();
  }
}
