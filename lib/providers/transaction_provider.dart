import 'package:flutter/foundation.dart';
import '../models/transaction.dart' as models;
import '../database/database_helper.dart';

/// Provider quản lý state cho giao dịch
class TransactionProvider extends ChangeNotifier {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;
  List<models.Transaction> _transactions = [];
  bool _isLoading = false;

  // Getters
  List<models.Transaction> get transactions => [..._transactions];
  bool get isLoading => _isLoading;

  /// Lấy tổng số tiền thu nhập
  double get totalIncome {
    return _transactions
        .where((t) => t.type == models.TransactionType.income)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  /// Lấy tổng số tiền chi tiêu
  double get totalExpense {
    return _transactions
        .where((t) => t.type == models.TransactionType.expense)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  /// Lấy số dư hiện tại
  double get balance => totalIncome - totalExpense;

  /// Khởi tạo và load dữ liệu từ database
  Future<void> loadTransactions() async {
    _isLoading = true;
    notifyListeners();

    try {
      _transactions = await _databaseHelper.getAll();
    } catch (e) {
      debugPrint('Error loading transactions: $e');
      _transactions = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Thêm giao dịch mới
  Future<void> addTransaction(models.Transaction transaction) async {
    try {
      final id = await _databaseHelper.insert(transaction);
      final newTransaction = transaction.copyWith(id: id);
      _transactions.insert(0, newTransaction); // Thêm vào đầu danh sách
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding transaction: $e');
      rethrow;
    }
  }

  /// Cập nhật giao dịch
  Future<void> updateTransaction(models.Transaction transaction) async {
    try {
      await _databaseHelper.update(transaction);
      final index = _transactions.indexWhere((t) => t.id == transaction.id);
      if (index != -1) {
        _transactions[index] = transaction;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating transaction: $e');
      rethrow;
    }
  }

  /// Xóa giao dịch
  Future<void> deleteTransaction(int id) async {
    try {
      await _databaseHelper.delete(id);
      _transactions.removeWhere((t) => t.id == id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting transaction: $e');
      rethrow;
    }
  }

  /// Lấy giao dịch theo khoảng thời gian
  Future<List<models.Transaction>> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      return await _databaseHelper.getByDateRange(startDate, endDate);
    } catch (e) {
      debugPrint('Error getting transactions by date range: $e');
      return [];
    }
  }

  /// Lấy giao dịch theo ngày cụ thể
  List<models.Transaction> getTransactionsByDate(DateTime date) {
    return _transactions.where((t) {
      return t.date.year == date.year &&
          t.date.month == date.month &&
          t.date.day == date.day;
    }).toList();
  }

  /// Lấy giao dịch theo tháng
  List<models.Transaction> getTransactionsByMonth(int year, int month) {
    return _transactions.where((t) {
      return t.date.year == year && t.date.month == month;
    }).toList();
  }

  /// Lấy giao dịch theo loại
  List<models.Transaction> getTransactionsByType(models.TransactionType type) {
    return _transactions.where((t) => t.type == type).toList();
  }

  /// Lấy giao dịch theo danh mục
  List<models.Transaction> getTransactionsByCategory(String category) {
    return _transactions.where((t) => t.category == category).toList();
  }

  /// Lấy danh sách các danh mục duy nhất
  List<String> get uniqueCategories {
    final categories = _transactions.map((t) => t.category).toSet().toList();
    categories.sort();
    return categories;
  }

  /// Tính tổng chi tiêu theo tháng
  double getMonthlyExpense(int year, int month) {
    return _transactions
        .where((t) =>
            t.type == models.TransactionType.expense &&
            t.date.year == year &&
            t.date.month == month)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  /// Tính tổng thu nhập theo tháng
  double getMonthlyIncome(int year, int month) {
    return _transactions
        .where((t) =>
            t.type == models.TransactionType.income &&
            t.date.year == year &&
            t.date.month == month)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  /// Tính tổng chi tiêu theo danh mục trong tháng
  Map<String, double> getExpensesByCategory(int year, int month) {
    Map<String, double> categoryTotals = {};
    
    final monthTransactions = _transactions.where((t) =>
        t.type == models.TransactionType.expense &&
        t.date.year == year &&
        t.date.month == month);

    for (var transaction in monthTransactions) {
      categoryTotals[transaction.category] =
          (categoryTotals[transaction.category] ?? 0) + transaction.amount;
    }

    return categoryTotals;
  }

  /// Tính tổng thu nhập theo danh mục trong tháng
  Map<String, double> getIncomesByCategory(int year, int month) {
    Map<String, double> categoryTotals = {};
    
    final monthTransactions = _transactions.where((t) =>
        t.type == models.TransactionType.income &&
        t.date.year == year &&
        t.date.month == month);

    for (var transaction in monthTransactions) {
      categoryTotals[transaction.category] =
          (categoryTotals[transaction.category] ?? 0) + transaction.amount;
    }

    return categoryTotals;
  }

  /// Lấy chi tiêu theo ngày trong tháng (cho bar chart)
  Map<int, double> getDailyExpenses(int year, int month) {
    Map<int, double> dailyTotals = {};
    
    final monthTransactions = _transactions.where((t) =>
        t.type == models.TransactionType.expense &&
        t.date.year == year &&
        t.date.month == month);

    for (var transaction in monthTransactions) {
      int day = transaction.date.day;
      dailyTotals[day] = (dailyTotals[day] ?? 0) + transaction.amount;
    }

    return dailyTotals;
  }

  /// Lấy chi tiêu theo tuần trong tháng
  Map<int, double> getWeeklyExpenses(int year, int month) {
    Map<int, double> weeklyTotals = {};
    
    final monthTransactions = _transactions.where((t) =>
        t.type == models.TransactionType.expense &&
        t.date.year == year &&
        t.date.month == month);

    for (var transaction in monthTransactions) {
      // Tính tuần trong tháng (1-5)
      int week = ((transaction.date.day - 1) ~/ 7) + 1;
      weeklyTotals[week] = (weeklyTotals[week] ?? 0) + transaction.amount;
    }

    return weeklyTotals;
  }

  /// Tính số dư trong tháng
  double getMonthlyBalance(int year, int month) {
    return getMonthlyIncome(year, month) - getMonthlyExpense(year, month);
  }

  /// Lấy danh mục chi tiêu nhiều nhất trong tháng
  String? getTopExpenseCategory(int year, int month) {
    final expenses = getExpensesByCategory(year, month);
    if (expenses.isEmpty) return null;

    return expenses.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }

  /// Tính trung bình chi tiêu mỗi ngày trong tháng
  double getAverageDailyExpense(int year, int month) {
    final monthExpense = getMonthlyExpense(year, month);
    if (monthExpense == 0) return 0;

    final daysInMonth = DateTime(year, month + 1, 0).day;
    return monthExpense / daysInMonth;
  }
}
