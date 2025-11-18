import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class ReaderDatabase {
  ReaderDatabase._internal();
  static final ReaderDatabase instance = ReaderDatabase._internal();

  static const _dbName = 'reader_settings.db';
  static const _settingsTable = 'reader_settings';
  static const _progressTable = 'reading_progress';

  Database? _database;

  Future<void> init() async {
    if (_database != null) return;
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, _dbName);
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_settingsTable (
            id INTEGER PRIMARY KEY,
            font_size REAL NOT NULL,
            theme_mode TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE $_progressTable (
            book_id TEXT PRIMARY KEY,
            chapter_index INTEGER NOT NULL,
            page_index INTEGER NOT NULL
          )
        ''');

        await db.insert(_settingsTable, {
          'id': 1,
          'font_size': 18,
          'theme_mode': 'system',
        });
      },
    );
  }

  Future<ReaderSettingsSnapshot> getReaderSettings() async {
    final db = _ensureDb();
    final result = await db.query(_settingsTable, limit: 1);
    if (result.isEmpty) {
      return ReaderSettingsSnapshot(fontSize: 18, themeMode: ThemeMode.system);
    }
    final row = result.first;
    return ReaderSettingsSnapshot(
      fontSize: (row['font_size'] as num).toDouble(),
      themeMode: _themeFromString(row['theme_mode'] as String),
    );
  }

  Future<void> saveReaderSettings({
    required double fontSize,
    required ThemeMode themeMode,
  }) async {
    final db = _ensureDb();
    await db.insert(
      _settingsTable,
      {
        'id': 1,
        'font_size': fontSize,
        'theme_mode': _themeToString(themeMode),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<BookProgress?> getBookProgress(String bookId) async {
    final db = _ensureDb();
    final result = await db.query(
      _progressTable,
      where: 'book_id = ?',
      whereArgs: [bookId],
      limit: 1,
    );
    if (result.isEmpty) return null;
    final row = result.first;
    return BookProgress(
      bookId: row['book_id'] as String,
      chapterIndex: row['chapter_index'] as int,
      pageIndex: row['page_index'] as int,
    );
  }

  Future<void> upsertBookProgress(BookProgress progress) async {
    final db = _ensureDb();
    await db.insert(
      _progressTable,
      {
        'book_id': progress.bookId,
        'chapter_index': progress.chapterIndex,
        'page_index': progress.pageIndex,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Database _ensureDb() {
    final db = _database;
    if (db == null) {
      throw StateError('Database has not been initialized. Call init() first.');
    }
    return db;
  }

  ThemeMode _themeFromString(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  String _themeToString(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
  }
}

class BookProgress {
  final String bookId;
  final int chapterIndex;
  final int pageIndex;

  const BookProgress({
    required this.bookId,
    required this.chapterIndex,
    required this.pageIndex,
  });

  BookProgress copyWith({
    int? chapterIndex,
    int? pageIndex,
  }) {
    return BookProgress(
      bookId: bookId,
      chapterIndex: chapterIndex ?? this.chapterIndex,
      pageIndex: pageIndex ?? this.pageIndex,
    );
  }
}

class ReaderSettingsSnapshot {
  final double fontSize;
  final ThemeMode themeMode;

  ReaderSettingsSnapshot({
    required this.fontSize,
    required this.themeMode,
  });
}

