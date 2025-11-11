import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/book.dart';

class BookService {
  // Đọc tất cả file .json trong assets và trả về danh sách BookInfo
  Future<List<BookInfo>> getBookList() async {
    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);

      final List<String> assetFiles = manifestMap.keys
          .where((String key) => key.startsWith('assets/') && key.endsWith('.json'))
          .toList();

      // Fallback khi manifest không chứa file .json (một số cấu hình/build)
      final List<String> candidates = assetFiles.isNotEmpty
          ? assetFiles
          : <String>['assets/lao_hac.json', 'assets/chi_pheo.json'];

      final List<BookInfo> books = [];
      for (final path in candidates) {
        try {
          final String jsonString = await rootBundle.loadString(path);
          final Map<String, dynamic> jsonData = json.decode(jsonString);
          books.add(BookInfo(
            title: jsonData['title'] ?? '',
            author: jsonData['author'] ?? '',
            chapters: (jsonData['chapters'] as List?)?.length ?? 0,
            path: path,
          ));
        } catch (e) {
          // Bỏ qua file lỗi, tiếp tục các file khác
          // Có thể log nếu cần
        }
      }

      return books;
    } catch (e) {
      // Trường hợp không đọc được manifest (ví dụ: không tồn tại trên nền tảng cụ thể)
      // Thử fallback trực tiếp
      final List<String> fallback = <String>['assets/lao_hac.json', 'assets/chi_pheo.json'];
      final List<BookInfo> books = [];
      for (final path in fallback) {
        try {
          final String jsonString = await rootBundle.loadString(path);
          final Map<String, dynamic> jsonData = json.decode(jsonString);
          books.add(BookInfo(
            title: jsonData['title'] ?? '',
            author: jsonData['author'] ?? '',
            chapters: (jsonData['chapters'] as List?)?.length ?? 0,
            path: path,
          ));
        } catch (_) {
          // ignore individual fallback errors
        }
      }
      if (books.isEmpty) {
        throw Exception('Không tìm thấy dữ liệu sách trong assets. Chi tiết: $e');
      }
      return books;
    }
  }

  Future<Book> loadBook(String path) async {
    try {
      final String jsonString = await rootBundle.loadString(path);
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      return Book.fromJson(jsonData);
    } catch (e) {
      throw Exception('Không thể tải sách: $e');
    }
  }
}
