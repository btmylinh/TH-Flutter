import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../core/usecases/usecase.dart';
import '../repositories/restaurant_repository.dart';

class CreateRestaurantParams {
  final String name;
  final String description;
  final String address;
  final String category;
  final String imageUrl;

  CreateRestaurantParams({
    required this.name,
    required this.description,
    required this.address,
    required this.category,
    required this.imageUrl,
  });
}

class CreateRestaurant extends UseCase<void, CreateRestaurantParams> {
  final RestaurantRepository repository;

  CreateRestaurant(this.repository);

  @override
  Future<Either<Failure, void>> call(CreateRestaurantParams params) async {
    return await repository.createRestaurant(
      name: params.name,
      description: params.description,
      address: params.address,
      category: params.category,
      imageUrl: params.imageUrl,
    );
  }
}
