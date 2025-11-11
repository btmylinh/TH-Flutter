import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/restaurant_repository.dart';

class AddRestaurant implements UseCase<String, Map<String, dynamic>> {
  final RestaurantRepository repository;
  AddRestaurant(this.repository);

  @override
  Future<Either<Failure, String>> call(Map<String, dynamic> params) {
    return repository.addRestaurant(params);
  }
}
