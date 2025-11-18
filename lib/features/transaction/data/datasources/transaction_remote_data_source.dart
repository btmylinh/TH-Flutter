import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/transaction_model.dart';

abstract class TransactionRemoteDataSource {
  Future<void> addTransaction(TransactionModel transaction);
  Future<void> updateTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String transactionId);
  Stream<List<TransactionModel>> getTransactions();
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  TransactionRemoteDataSourceImpl({
    required this.firestore,
    required this.firebaseAuth,
  });

  String get _userId {
    final user = firebaseAuth.currentUser;
    if (user == null) {
      throw AuthException('Người dùng chưa đăng nhập');
    }
    return user.uid;
  }

  CollectionReference get _transactionsCollection {
    return firestore
        .collection('users')
        .doc(_userId)
        .collection('transactions');
  }

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    try {
      await _transactionsCollection.add(transaction.toFirestore());
    } catch (e) {
      throw ServerException('Không thể thêm giao dịch: ${e.toString()}');
    }
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    try {
      if (transaction.id == null) {
        throw ValidationException('ID giao dịch không hợp lệ');
      }
      await _transactionsCollection
          .doc(transaction.id)
          .update(transaction.toFirestore());
    } catch (e) {
      throw ServerException('Không thể cập nhật giao dịch: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteTransaction(String transactionId) async {
    try {
      await _transactionsCollection.doc(transactionId).delete();
    } catch (e) {
      throw ServerException('Không thể xóa giao dịch: ${e.toString()}');
    }
  }

  @override
  Stream<List<TransactionModel>> getTransactions() {
    try {
      return _transactionsCollection
          .orderBy('date', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) => TransactionModel.fromFirestore(doc))
                .toList();
          });
    } catch (e) {
      throw ServerException(
        'Không thể lấy danh sách giao dịch: ${e.toString()}',
      );
    }
  }
}
