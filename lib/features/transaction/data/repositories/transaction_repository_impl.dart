import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_remote_data_source.dart';
import '../models/transaction_model.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;

  TransactionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> addTransaction(
    TransactionEntity transaction,
  ) async {
    try {
      final model = TransactionModel.fromEntity(transaction);
      await remoteDataSource.addTransaction(model);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(TransactionFailure(e.message));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(TransactionFailure('Lỗi không xác định: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> updateTransaction(
    TransactionEntity transaction,
  ) async {
    try {
      final model = TransactionModel.fromEntity(transaction);
      await remoteDataSource.updateTransaction(model);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(TransactionFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } catch (e) {
      return Left(TransactionFailure('Lỗi không xác định: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteTransaction(String transactionId) async {
    try {
      await remoteDataSource.deleteTransaction(transactionId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(TransactionFailure(e.message));
    } catch (e) {
      return Left(TransactionFailure('Lỗi không xác định: ${e.toString()}'));
    }
  }

  @override
  Stream<Either<Failure, List<TransactionEntity>>> getTransactions() {
    try {
      return remoteDataSource
          .getTransactions()
          .map((transactions) {
            return Right<Failure, List<TransactionEntity>>(transactions);
          })
          .handleError((error) {
            if (error is ServerException) {
              return Left<Failure, List<TransactionEntity>>(
                TransactionFailure(error.message),
              );
            }
            return Left<Failure, List<TransactionEntity>>(
              TransactionFailure('Lỗi không xác định: ${error.toString()}'),
            );
          });
    } catch (e) {
      return Stream.value(
        Left(TransactionFailure('Lỗi không xác định: ${e.toString()}')),
      );
    }
  }
}
