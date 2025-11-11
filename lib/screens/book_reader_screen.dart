import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/preferences_service.dart';
import '../widgets/book_page_painter.dart';
import '../widgets/table_of_contents.dart';
import '../widgets/settings_dialog.dart';
import '../theme/theme_controller.dart';

class BookReaderScreen extends StatefulWidget {
  final Book book;

  const BookReaderScreen({super.key, required this.book});

  @override
  State<BookReaderScreen> createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends State<BookReaderScreen> {
  final PreferencesService _prefsService = PreferencesService();
  final PageController _pageController = PageController();

  int _currentChapterIndex = 0;
  int _currentPageIndex = 0;
  double _fontSize = 18.0;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final fontSize = await _prefsService.getFontSize();
    final currentChapter = await _prefsService.getCurrentChapter();
    final currentPage = await _prefsService.getCurrentPage();

    setState(() {
      _fontSize = fontSize;
      _currentChapterIndex = currentChapter;
      _currentPageIndex = currentPage;
    });

    // Jump to saved page
    if (_currentPageIndex > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_pageController.hasClients) {
          _pageController.jumpToPage(_currentPageIndex);
        }
      });
    }
  }

  Future<void> _saveFontSize(double size) async {
    await _prefsService.setFontSize(size);
    setState(() {
      _fontSize = size;
    });
  }

  Future<void> _saveCurrentPage(int page) async {
    await _prefsService.setCurrentPage(page);
  }

  Future<void> _saveCurrentChapter(int chapter) async {
    await _prefsService.setCurrentChapter(chapter);
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPageIndex = page;
    });
    _saveCurrentPage(page);
  }

  void _showTableOfContents() {
    showDialog(
      context: context,
      builder: (context) => TableOfContentsDialog(
        book: widget.book,
        currentChapterIndex: _currentChapterIndex,
        onChapterSelected: (index) {
          setState(() {
            _currentChapterIndex = index;
            _currentPageIndex = 0;
          });
          _saveCurrentChapter(index);
          _saveCurrentPage(0);
          _pageController.jumpToPage(0);
        },
      ),
    );
  }

  void _showSettings() {
    showDialog(
      context: context,
      builder: (context) => SettingsDialog(
        currentFontSize: _fontSize,
        onFontSizeChanged: _saveFontSize,
      ),
    );
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  List<String> _splitChapterIntoPages(Chapter chapter) {
    // Ước tính số ký tự mỗi trang dựa trên kích thước chữ
    final charsPerPage = (1000 / (_fontSize / 18)).round();
    final content = chapter.content;
    final List<String> pages = [];

    int start = 0;
    while (start < content.length) {
      int end = start + charsPerPage;
      if (end >= content.length) {
        end = content.length;
      } else {
        // Tìm điểm ngắt hợp lý (sau dấu chấm, xuống dòng, hoặc khoảng trắng)
        final substring = content.substring(start, end);
        final lastNewline = substring.lastIndexOf('\n');
        final lastPeriod = substring.lastIndexOf('.');
        final lastSpace = substring.lastIndexOf(' ');

        final breakPoint = [
          lastNewline,
          lastPeriod,
          lastSpace,
        ].where((i) => i > 0).fold(0, (max, i) => i > max ? i : max);

        if (breakPoint > 0) {
          end = start + breakPoint + 1;
        }
      }

      pages.add(content.substring(start, end));
      start = end;
    }

    return pages;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final surfaceColor = colorScheme.surface;
    final onSurfaceColor = colorScheme.onSurface;
    final currentChapter = widget.book.chapters[_currentChapterIndex];
    final pages = _splitChapterIntoPages(currentChapter);

    return Scaffold(
      backgroundColor: surfaceColor,
      appBar: _showControls
          ? AppBar(
              title: Text(widget.book.title),
              backgroundColor: surfaceColor,
              foregroundColor: onSurfaceColor,
              actions: [
                ValueListenableBuilder<ThemeMode>(
                  valueListenable: ThemeController.instance.themeModeNotifier,
                  builder: (context, mode, _) {
                    IconData icon = switch (mode) {
                      ThemeMode.light => Icons.light_mode_rounded,
                      ThemeMode.dark => Icons.dark_mode_rounded,
                      ThemeMode.system => Icons.brightness_auto_rounded,
                    };
                    return PopupMenuButton<ThemeMode>(
                      tooltip: 'Chế độ giao diện',
                      icon: Icon(icon),
                      onSelected: (value) {
                        ThemeController.instance.setThemeMode(value);
                      },
                      itemBuilder: (context) => <PopupMenuEntry<ThemeMode>>[
                        PopupMenuItem<ThemeMode>(
                          value: ThemeMode.system,
                          child: Row(
                            children: [
                              Icon(
                                Icons.brightness_auto_rounded,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              const SizedBox(width: 12),
                              const Text('Theo hệ thống'),
                              const Spacer(),
                              if (mode == ThemeMode.system) const Icon(Icons.check_rounded),
                            ],
                          ),
                        ),
                        PopupMenuItem<ThemeMode>(
                          value: ThemeMode.light,
                          child: Row(
                            children: [
                              Icon(
                                Icons.light_mode_rounded,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              const SizedBox(width: 12),
                              const Text('Sáng'),
                              const Spacer(),
                              if (mode == ThemeMode.light) const Icon(Icons.check_rounded),
                            ],
                          ),
                        ),
                        PopupMenuItem<ThemeMode>(
                          value: ThemeMode.dark,
                          child: Row(
                            children: [
                              Icon(
                                Icons.dark_mode_rounded,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              const SizedBox(width: 12),
                              const Text('Tối'),
                              const Spacer(),
                              if (mode == ThemeMode.dark) const Icon(Icons.check_rounded),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: _showSettings,
                  tooltip: 'Cài đặt',
                ),
              ],
            )
          : null,
      body: GestureDetector(
        onTap: _toggleControls,
        child: PageView.builder(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          itemCount: pages.length,
          itemBuilder: (context, index) {
            return CustomPaint(
              painter: BookPagePainter(
                text: pages[index],
                fontSize: _fontSize,
                textColor: onSurfaceColor,
                backgroundColor: surfaceColor,
              ),
              child: Container(),
            );
          },
        ),
      ),
      bottomNavigationBar: _showControls
          ? BottomNavigationBar(
              backgroundColor: surfaceColor,
              selectedItemColor: colorScheme.primary,
              unselectedItemColor: onSurfaceColor.withOpacity(0.8),
              currentIndex: 0,
              onTap: (index) {
                switch (index) {
                  case 0:
                    _showTableOfContents();
                    break;
                  case 1:
                    if (_currentChapterIndex > 0) {
                      setState(() {
                        _currentChapterIndex--;
                        _currentPageIndex = 0;
                      });
                      _saveCurrentChapter(_currentChapterIndex);
                      _saveCurrentPage(0);
                      _pageController.jumpToPage(0);
                    }
                    break;
                  case 2:
                    if (_currentChapterIndex <
                        widget.book.chapters.length - 1) {
                      setState(() {
                        _currentChapterIndex++;
                        _currentPageIndex = 0;
                      });
                      _saveCurrentChapter(_currentChapterIndex);
                      _saveCurrentPage(0);
                      _pageController.jumpToPage(0);
                    }
                    break;
                }
              },
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.list),
                  label: 'Mục lục',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.arrow_back,
                    color: _currentChapterIndex > 0
                        ? null
                        : onSurfaceColor.withOpacity(0.3),
                  ),
                  label: 'Chương trước',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.arrow_forward,
                    color:
                        _currentChapterIndex < widget.book.chapters.length - 1
                            ? null
                            : onSurfaceColor.withOpacity(0.3),
                  ),
                  label: 'Chương sau',
                ),
              ],
            )
          : null,
      floatingActionButton: _showControls
          ? Padding(
              padding: const EdgeInsets.only(right: 6, bottom: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FloatingActionButton.small(
                    heroTag: 'progress',
                    onPressed: () {
                      final progress =
                          ((_currentChapterIndex) /
                                  widget.book.chapters.length *
                                  100)
                              .toStringAsFixed(0);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Tiến độ đọc: $progress%'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    child: const Icon(Icons.percent),
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton.small(
                    heroTag: 'info',
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Thông tin'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Sách: ${widget.book.title}'),
                              Text('Tác giả: ${widget.book.author}'),
                              const SizedBox(height: 10),
                              Text(
                                'Chương ${_currentChapterIndex + 1}/${widget.book.chapters.length}',
                              ),
                              Text(
                                'Trang ${_currentPageIndex + 1}/${pages.length}',
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('Đóng'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: const Icon(Icons.info_outline),
                  ),
                ],
              ),
            )
          : null,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
