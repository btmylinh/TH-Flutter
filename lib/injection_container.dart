import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

// Core services
import 'core/services/cloudinary_service.dart';

// Data sources
import 'data/datasources/auth_remote_data_source.dart';
import 'data/datasources/restaurant_remote_data_source.dart';
import 'data/datasources/review_remote_data_source.dart';

// Repositories
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/restaurant_repository_impl.dart';
import 'data/repositories/review_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/restaurant_repository.dart';
import 'domain/repositories/review_repository.dart';

// Use cases
import 'domain/usecases/sign_in_with_email.dart';
import 'domain/usecases/sign_up_with_email.dart';
import 'domain/usecases/sign_out.dart';
import 'domain/usecases/get_current_user.dart';
import 'domain/usecases/get_restaurants.dart';
import 'domain/usecases/create_restaurant.dart';
import 'domain/usecases/delete_restaurant.dart';
import 'domain/usecases/get_reviews.dart';
import 'domain/usecases/add_review.dart';

// BLoC
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/restaurant/restaurant_bloc.dart';
import 'presentation/bloc/review/review_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ============ BLoC ============
  sl.registerFactory(
    () => AuthBloc(
      signInWithEmail: sl(),
      signUpWithEmail: sl(),
      signOut: sl(),
      getCurrentUser: sl(),
    ),
  );

  sl.registerFactory(
    () => RestaurantBloc(
      getRestaurants: sl(),
      createRestaurantUseCase: sl(),
      deleteRestaurantUseCase: sl(),
    ),
  );

  sl.registerFactory(() => ReviewBloc(getReviews: sl(), addReview: sl()));

  // ============ Use Cases ============
  sl.registerLazySingleton(() => SignInWithEmail(sl()));
  sl.registerLazySingleton(() => SignUpWithEmail(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => GetRestaurants(sl()));
  sl.registerLazySingleton(() => CreateRestaurant(sl()));
  sl.registerLazySingleton(() => DeleteRestaurant(sl()));
  sl.registerLazySingleton(() => GetReviews(sl()));
  sl.registerLazySingleton(() => AddReview(sl()));

  // ============ Repositories ============
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<RestaurantRepository>(
    () => RestaurantRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<ReviewRepository>(
    () => ReviewRepositoryImpl(remoteDataSource: sl()),
  );

  // ============ Data Sources ============
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(firebaseAuth: sl(), firestore: sl()),
  );

  sl.registerLazySingleton<RestaurantRemoteDataSource>(
    () => RestaurantRemoteDataSourceImpl(firestore: sl()),
  );

  sl.registerLazySingleton<ReviewRemoteDataSource>(
    () => ReviewRemoteDataSourceImpl(
      firestore: sl(),
      cloudinaryService: sl(),
      firebaseAuth: sl(),
    ),
  );

  // ============ Core Services ============
  sl.registerLazySingleton(() => CloudinaryService.instance);

  // ============ External ============
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseMessaging.instance);
}
