import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/restaurant_entity.dart';
import '../../domain/repositories/restaurant_repository.dart';
import '../datasources/restaurant_remote_data_source.dart';

class RestaurantRepositoryImpl implements RestaurantRepository {
  final RestaurantRemoteDataSource remoteDataSource;

  RestaurantRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<Either<Failure, List<RestaurantEntity>>> getRestaurants() {
    return remoteDataSource
        .getRestaurants()
        .map<Either<Failure, List<RestaurantEntity>>>((restaurants) {
          return Right(restaurants);
        })
        .handleError((error) {
          return Left(ServerFailure(error.toString()));
        });
  }

  @override
  Future<Either<Failure, RestaurantEntity>> getRestaurantById(String id) async {
    try {
      final restaurant = await remoteDataSource.getRestaurantById(id);
      return Right(restaurant);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, RestaurantEntity>> watchRestaurant(String id) {
    return remoteDataSource
        .watchRestaurant(id)
        .map<Either<Failure, RestaurantEntity>>((restaurant) {
          return Right(restaurant);
        })
        .handleError((error) {
          return Left(ServerFailure(error.toString()));
        });
  }

  @override
  Future<Either<Failure, void>> createRestaurant({
    required String name,
    required String description,
    required String address,
    required String category,
    required String imageUrl,
  }) async {
    try {
      await remoteDataSource.createRestaurant(
        name: name,
        description: description,
        address: address,
        category: category,
        imageUrl: imageUrl,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteRestaurant(String id) async {
    try {
      await remoteDataSource.deleteRestaurant(id);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
