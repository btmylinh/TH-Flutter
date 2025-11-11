import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/transaction.dart' as models;

/// Helper class để quản lý database SQLite
class DatabaseHelper {
  // Singleton pattern
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  /// Getter để lấy database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('transactions.db');
    return _database!;
  }

  /// Khởi tạo database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  /// Tạo bảng transactions
  Future<void> _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const doubleType = 'REAL NOT NULL';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';

    await db.execute('''
      CREATE TABLE transactions (
        id $idType,
        amount $doubleType,
        description $textType,
        date $textType,
        type $intType,
        category $textType
      )
    ''');
  }

  /// Thêm giao dịch mới vào database
  /// Returns: ID của giao dịch vừa được thêm
  Future<int> insert(models.Transaction transaction) async {
    final db = await instance.database;
    return await db.insert('transactions', transaction.toMap());
  }

  /// Lấy tất cả giao dịch từ database
  /// Returns: Danh sách các giao dịch, sắp xếp theo ngày giảm dần
  Future<List<models.Transaction>> getAll() async {
    final db = await instance.database;
    final result = await db.query(
      'transactions',
      orderBy: 'date DESC', // Sắp xếp theo ngày mới nhất
    );

    return result.map((map) => models.Transaction.fromMap(map)).toList();
  }

  /// Lấy giao dịch theo ID
  /// Returns: Transaction nếu tìm thấy, null nếu không tìm thấy
  Future<models.Transaction?> getById(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return models.Transaction.fromMap(maps.first);
    }
    return null;
  }

  /// Cập nhật giao dịch
  /// Returns: Số lượng rows được cập nhật
  Future<int> update(models.Transaction transaction) async {
    final db = await instance.database;
    return await db.update(
      'transactions',
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  /// Xóa giao dịch theo ID
  /// Returns: Số lượng rows được xóa
  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Lấy giao dịch theo loại (Chi tiêu hoặc Thu nhập)
  Future<List<models.Transaction>> getByType(models.TransactionType type) async {
    final db = await instance.database;
    final result = await db.query(
      'transactions',
      where: 'type = ?',
      whereArgs: [type.index],
      orderBy: 'date DESC',
    );

    return result.map((map) => models.Transaction.fromMap(map)).toList();
  }

  /// Lấy giao dịch theo danh mục
  Future<List<models.Transaction>> getByCategory(String category) async {
    final db = await instance.database;
    final result = await db.query(
      'transactions',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'date DESC',
    );

    return result.map((map) => models.Transaction.fromMap(map)).toList();
  }

  /// Lấy giao dịch trong khoảng thời gian
  Future<List<models.Transaction>> getByDateRange(
      DateTime startDate, DateTime endDate) async {
    final db = await instance.database;
    final result = await db.query(
      'transactions',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [
        startDate.toIso8601String(),
        endDate.toIso8601String(),
      ],
      orderBy: 'date DESC',
    );

    return result.map((map) => models.Transaction.fromMap(map)).toList();
  }

  /// Tính tổng số tiền theo loại giao dịch
  Future<double> getTotalByType(models.TransactionType type) async {
    final db = await instance.database;
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM transactions WHERE type = ?',
      [type.index],
    );

    final total = result.first['total'];
    return total != null ? total as double : 0.0;
  }

  /// Xóa tất cả giao dịch (dùng cho testing hoặc reset data)
  Future<int> deleteAll() async {
    final db = await instance.database;
    return await db.delete('transactions');
  }

  /// Đóng database
  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }
}
