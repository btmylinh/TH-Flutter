import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user.dart';
import '../../features/auth/domain/usecases/sign_in.dart';
import '../../features/auth/domain/usecases/sign_out.dart';
import '../../features/auth/domain/usecases/sign_up.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';

import '../../features/transaction/data/datasources/transaction_remote_data_source.dart';
import '../../features/transaction/data/repositories/transaction_repository_impl.dart';
import '../../features/transaction/domain/repositories/transaction_repository.dart';
import '../../features/transaction/domain/usecases/add_transaction.dart';
import '../../features/transaction/domain/usecases/delete_transaction.dart';
import '../../features/transaction/domain/usecases/get_transactions.dart';
import '../../features/transaction/domain/usecases/update_transaction.dart';
import '../../features/transaction/presentation/cubit/transaction_cubit.dart';

import '../../features/analytics/data/repositories/analytics_repository_impl.dart';
import '../../features/analytics/domain/repositories/analytics_repository.dart';
import '../../features/analytics/domain/usecases/get_category_stats.dart';
import '../../features/analytics/domain/usecases/get_monthly_trend.dart';
import '../../features/analytics/presentation/cubit/analytics_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Auth
  // Cubit
  sl.registerFactory(
    () => AuthCubit(
      signIn: sl(),
      signUp: sl(),
      signOut: sl(),
      getCurrentUser: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => SignIn(sl()));
  sl.registerLazySingleton(() => SignUp(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(firebaseAuth: sl()),
  );

  // Features - Transaction
  // Cubit
  sl.registerFactory(
    () => TransactionCubit(
      addTransaction: sl(),
      getTransactions: sl(),
      updateTransaction: sl(),
      deleteTransaction: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => AddTransaction(sl()));
  sl.registerLazySingleton(() => GetTransactions(sl()));
  sl.registerLazySingleton(() => UpdateTransaction(sl()));
  sl.registerLazySingleton(() => DeleteTransaction(sl()));

  // Repository
  sl.registerLazySingleton<TransactionRepository>(
    () => TransactionRepositoryImpl(remoteDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<TransactionRemoteDataSource>(
    () => TransactionRemoteDataSourceImpl(firestore: sl(), firebaseAuth: sl()),
  );

  // Features - Analytics
  // Cubit
  sl.registerFactory(
    () => AnalyticsCubit(getCategoryStats: sl(), getMonthlyTrend: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => GetCategoryStats(sl()));
  sl.registerLazySingleton(() => GetMonthlyTrend(sl()));

  // Repository
  sl.registerLazySingleton<AnalyticsRepository>(
    () => AnalyticsRepositoryImpl(transactionRepository: sl()),
  );

  // External
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
}
