import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/usecases/add_transaction.dart';
import '../../domain/usecases/delete_transaction.dart';
import '../../domain/usecases/get_transactions.dart';
import '../../domain/usecases/update_transaction.dart';
import 'transaction_state.dart';

class TransactionCubit extends Cubit<TransactionState> {
  final AddTransaction addTransaction;
  final GetTransactions getTransactions;
  final UpdateTransaction updateTransaction;
  final DeleteTransaction deleteTransaction;

  StreamSubscription? _transactionSubscription;

  TransactionCubit({
    required this.addTransaction,
    required this.getTransactions,
    required this.updateTransaction,
    required this.deleteTransaction,
  }) : super(TransactionInitial());

  Future<void> loadTransactions() async {
    emit(TransactionLoading());
    final result = await getTransactions(NoParams());

    result.fold((failure) => emit(TransactionError(failure.message)), (stream) {
      _transactionSubscription?.cancel();
      _transactionSubscription = stream.listen((either) {
        either.fold(
          (failure) => emit(TransactionError(failure.message)),
          (transactions) => emit(TransactionLoaded(transactions)),
        );
      });
    });
  }

  Future<void> add(TransactionEntity transaction) async {
    final result = await addTransaction(
      AddTransactionParams(transaction: transaction),
    );

    result.fold(
      (failure) => emit(TransactionError(failure.message)),
      (_) => emit(const TransactionActionSuccess('Thêm giao dịch thành công')),
    );
  }

  Future<void> update(TransactionEntity transaction) async {
    final result = await updateTransaction(
      UpdateTransactionParams(transaction: transaction),
    );

    result.fold(
      (failure) => emit(TransactionError(failure.message)),
      (_) =>
          emit(const TransactionActionSuccess('Cập nhật giao dịch thành công')),
    );
  }

  Future<void> delete(String transactionId) async {
    final result = await deleteTransaction(
      DeleteTransactionParams(transactionId: transactionId),
    );

    result.fold(
      (failure) => emit(TransactionError(failure.message)),
      (_) => emit(const TransactionActionSuccess('Xóa giao dịch thành công')),
    );
  }

  @override
  Future<void> close() {
    _transactionSubscription?.cancel();
    return super.close();
  }
}
