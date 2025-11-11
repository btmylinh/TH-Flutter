/// Enum định nghĩa loại giao dịch
enum TransactionType {
  expense, // Chi tiêu
  income, // Thu nhập
}

/// Model cho giao dịch tài chính
class Transaction {
  final int? id; // ID tự động tăng, nullable khi insert mới
  final double amount; // Số tiền
  final String description; // Mô tả giao dịch
  final DateTime date; // Ngày giao dịch
  final TransactionType type; // Loại: Chi tiêu hoặc Thu nhập
  final String category; // Danh mục (ăn uống, mua sắm, lương, ...)

  Transaction({
    this.id,
    required this.amount,
    required this.description,
    required this.date,
    required this.type,
    required this.category,
  });

  /// Chuyển đổi Transaction thành Map để lưu vào database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'description': description,
      'date': date.toIso8601String(), // Lưu dạng ISO8601 string
      'type': type.index, // Lưu enum dưới dạng số (0: expense, 1: income)
      'category': category,
    };
  }

  /// Tạo Transaction từ Map (đọc từ database)
  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as int?,
      amount: map['amount'] as double,
      description: map['description'] as String,
      date: DateTime.parse(map['date'] as String), // Parse từ ISO8601 string
      type: TransactionType.values[map['type'] as int], // Chuyển từ số về enum
      category: map['category'] as String,
    );
  }

  /// Copy with method để tạo bản sao với một số thuộc tính thay đổi
  Transaction copyWith({
    int? id,
    double? amount,
    String? description,
    DateTime? date,
    TransactionType? type,
    String? category,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      date: date ?? this.date,
      type: type ?? this.type,
      category: category ?? this.category,
    );
  }

  @override
  String toString() {
    return 'Transaction{id: $id, amount: $amount, description: $description, date: $date, type: $type, category: $category}';
  }
}
