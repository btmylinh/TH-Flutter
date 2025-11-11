import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/book.dart';

class BookService {
  // Đọc tất cả file .json trong assets và trả về danh sách BookInfo
  Future<List<BookInfo>> getBookList() async {
    final manifestContent = await rootBundle.loadString('AssetManifest.json');
    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    final List<String> assetFiles = manifestMap.keys
        .where((String key) => key.startsWith('assets/') && key.endsWith('.json'))
        .toList();

    List<BookInfo> books = [];
    for (final path in assetFiles) {
      final String jsonString = await rootBundle.loadString(path);
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      books.add(BookInfo(
        title: jsonData['title'] ?? '',
        author: jsonData['author'] ?? '',
        chapters: (jsonData['chapters'] as List?)?.length ?? 0,
        path: path,
      ));
    }
    return books;
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
