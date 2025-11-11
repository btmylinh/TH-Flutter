import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _fontSizeKey = 'font_size';
  static const String _isDarkModeKey = 'is_dark_mode';
  static const String _currentPageKey = 'current_page';
  static const String _currentChapterKey = 'current_chapter';

  // Font size
  Future<double> getFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_fontSizeKey) ?? 18.0;
  }

  Future<void> setFontSize(double size) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_fontSizeKey, size);
  }

  // Dark mode
  Future<bool> getIsDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isDarkModeKey) ?? false;
  }

  Future<void> setIsDarkMode(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isDarkModeKey, isDark);
  }

  // Current page
  Future<int> getCurrentPage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_currentPageKey) ?? 0;
  }

  Future<void> setCurrentPage(int page) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_currentPageKey, page);
  }

  // Current chapter
  Future<int> getCurrentChapter() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_currentChapterKey) ?? 0;
  }

  Future<void> setCurrentChapter(int chapter) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_currentChapterKey, chapter);
  }
}
