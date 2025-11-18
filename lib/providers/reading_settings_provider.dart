import 'package:flutter/material.dart';

import '../services/database_service.dart';

class ReadingSettingsProvider extends ChangeNotifier {
  final ReaderDatabase _database = ReaderDatabase.instance;

  bool _isReady = false;
  double _fontSize = 18;
  ThemeMode _themeMode = ThemeMode.system;
  final Map<String, BookProgress> _cachedProgress = {};

  bool get isReady => _isReady;
  double get fontSize => _fontSize;
  ThemeMode get themeMode => _themeMode;

  Future<void> load() async {
    if (_isReady) return;
    final settings = await _database.getReaderSettings();
    _fontSize = settings.fontSize;
    _themeMode = settings.themeMode;
    _isReady = true;
    notifyListeners();
  }

  Future<void> updateFontSize(double size) async {
    _fontSize = size;
    notifyListeners();
    await _database.saveReaderSettings(fontSize: _fontSize, themeMode: _themeMode);
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    await _database.saveReaderSettings(fontSize: _fontSize, themeMode: _themeMode);
  }

  Future<BookProgress> getProgress(String bookId) async {
    if (_cachedProgress.containsKey(bookId)) {
      return _cachedProgress[bookId]!;
    }
    final progress = await _database.getBookProgress(bookId) ??
        BookProgress(bookId: bookId, chapterIndex: 0, pageIndex: 0);
    _cachedProgress[bookId] = progress;
    return progress;
  }

  Future<void> updateProgress(
    String bookId, {
    int? chapterIndex,
    int? pageIndex,
  }) async {
    final existing = _cachedProgress[bookId] ??
        BookProgress(bookId: bookId, chapterIndex: 0, pageIndex: 0);
    final updated = existing.copyWith(
      chapterIndex: chapterIndex,
      pageIndex: pageIndex,
    );
    _cachedProgress[bookId] = updated;
    notifyListeners();
    await _database.upsertBookProgress(updated);
  }
}

