import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/transaction_entity.dart';

abstract class TransactionRepository {
  Future<Either<Failure, void>> addTransaction(TransactionEntity transaction);
  Future<Either<Failure, void>> updateTransaction(
    TransactionEntity transaction,
  );
  Future<Either<Failure, void>> deleteTransaction(String transactionId);
  Stream<Either<Failure, List<TransactionEntity>>> getTransactions();
}
