import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/restaurant.dart';
import '../../domain/repositories/restaurant_repository.dart';
import '../datasources/restaurant_remote_data_source.dart';

class RestaurantRepositoryImpl implements RestaurantRepository {
  final RestaurantRemoteDataSource remoteDataSource;

  RestaurantRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Restaurant>>> getRestaurants() async {
    try {
      final restaurants = await remoteDataSource.getRestaurants();
      return Right(restaurants);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Restaurant>> getRestaurantDetail(String id) async {
    try {
      final restaurant = await remoteDataSource.getRestaurantDetail(id);
      return Right(restaurant);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> addRestaurant(
    Map<String, dynamic> data,
  ) async {
    try {
      final id = await remoteDataSource.addRestaurant(data);
      return Right(id);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
