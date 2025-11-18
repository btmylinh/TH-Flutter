import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../models/book.dart';

class BookService {
  static const _remoteEndpoint = 'https://gutendex.com/books';

  Future<List<BookInfo>> getBookList() async {
    final results = await Future.wait<List<BookInfo>>([
      _loadAssetBooks(),
      _loadRemoteBooks(),
    ]);
    return results.expand((list) => list).toList();
  }

  Future<Book> loadBook(BookInfo info) async {
    switch (info.source) {
      case BookSource.asset:
        if (info.assetPath == null) {
          throw Exception('Không tìm thấy đường dẫn asset cho sách này.');
        }
        return _loadAssetBook(info.assetPath!);
      case BookSource.remote:
        if (info.remoteId == null) {
          throw Exception('Thiếu thông tin API cho sách trực tuyến.');
        }
        return _loadRemoteBook(info.remoteId!);
    }
  }

  Future<List<BookInfo>> _loadAssetBooks() async {
    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);

      final List<String> assetFiles = manifestMap.keys
          .where((String key) => key.startsWith('assets/') && key.endsWith('.json'))
          .toList();

      final List<String> candidates = assetFiles.isNotEmpty
          ? assetFiles
          : <String>['assets/lao_hac.json', 'assets/chi_pheo.json', 'assets/book.json'];

      final List<BookInfo> books = [];
      for (final path in candidates) {
        try {
          final String jsonString = await rootBundle.loadString(path);
          final Map<String, dynamic> jsonData = json.decode(jsonString);
          books.add(BookInfo(
            id: path,
            title: jsonData['title'] ?? '',
            author: jsonData['author'] ?? '',
            chapters: (jsonData['chapters'] as List?)?.length ?? 0,
            source: BookSource.asset,
            assetPath: path,
          ));
        } catch (_) {
          // ignore file level errors
        }
      }
      return books;
    } catch (_) {
      return [];
    }
  }

  Future<List<BookInfo>> _loadRemoteBooks() async {
    try {
      final uri = Uri.parse('$_remoteEndpoint/?page=1');
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        throw Exception('Remote API error ${response.statusCode}');
      }
      final jsonData = json.decode(response.body) as Map<String, dynamic>;
      final List<dynamic> books = jsonData['results'] as List<dynamic>;
      return books.take(8).map((raw) {
        final map = raw as Map<String, dynamic>;
        final id = map['id'].toString();
        String authorName = 'N/A';
        if (map['authors'] is List && (map['authors'] as List).isNotEmpty) {
          final firstAuthor = (map['authors'] as List).first as Map<String, dynamic>;
          authorName = firstAuthor['name'] as String? ?? 'N/A';
        }
        final coverUrl = (map['formats'] as Map<String, dynamic>?)?['image/jpeg'] as String?;
        return BookInfo(
          id: 'remote_$id',
          title: map['title'] as String? ?? 'Chưa rõ',
          author: authorName,
          chapters: (map['summaries'] is List && (map['summaries'] as List).isNotEmpty) ? 3 : 2,
          source: BookSource.remote,
          remoteId: id,
          coverUrl: coverUrl,
        );
      }).toList();
    } catch (_) {
      return [];
    }
  }

  Future<Book> _loadAssetBook(String path) async {
    try {
      final String jsonString = await rootBundle.loadString(path);
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      return Book.fromJson(jsonData);
    } catch (e) {
      throw Exception('Không thể tải sách từ tài nguyên: $e');
    }
  }

  Future<Book> _loadRemoteBook(String remoteId) async {
    try {
      final uri = Uri.parse('$_remoteEndpoint/$remoteId');
      final response = await http.get(uri);
      if (response.statusCode != 200) {
        throw Exception('Không tải được dữ liệu sách trực tuyến.');
      }
      final data = json.decode(response.body) as Map<String, dynamic>;
      final summaries = (data['summaries'] as List?)?.cast<String>() ?? [];
      final subjects = (data['subjects'] as List?)?.cast<String>() ?? [];
      final languages = (data['languages'] as List?)?.cast<String>() ?? [];
      String authorName = 'N/A';
      if (data['authors'] is List && (data['authors'] as List).isNotEmpty) {
        final firstAuthor = (data['authors'] as List).first as Map<String, dynamic>;
        authorName = firstAuthor['name'] as String? ?? 'N/A';
      }

      final List<Chapter> chapters = [];
      if (summaries.isNotEmpty) {
        chapters.add(Chapter(title: 'Tổng quan', content: summaries.first));
      }
      if (subjects.isNotEmpty) {
        chapters.add(Chapter(title: 'Chủ đề', content: subjects.join(', ')));
      }
      if (languages.isNotEmpty) {
        chapters.add(Chapter(title: 'Ngôn ngữ', content: languages.join(', ')));
      }
      if (chapters.isEmpty) {
        chapters.add(Chapter(
          title: 'Thông tin',
          content: 'Dữ liệu chi tiết đang được cập nhật.',
        ));
      }

      return Book(
        title: data['title'] as String? ?? 'Sách trực tuyến',
        author: authorName,
        chapters: chapters,
      );
    } catch (e) {
      throw Exception('Không thể tải sách trực tuyến: $e');
    }
  }
}
