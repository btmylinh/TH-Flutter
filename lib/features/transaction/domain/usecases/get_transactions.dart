import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/transaction_entity.dart';
import '../repositories/transaction_repository.dart';

class GetTransactions
    implements
        UseCase<Stream<Either<Failure, List<TransactionEntity>>>, NoParams> {
  final TransactionRepository repository;

  GetTransactions(this.repository);

  @override
  Future<Either<Failure, Stream<Either<Failure, List<TransactionEntity>>>>>
  call(NoParams params) async {
    return Right(repository.getTransactions());
  }
}
