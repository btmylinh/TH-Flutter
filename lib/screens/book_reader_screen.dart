import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book.dart';
import '../providers/reading_settings_provider.dart';
import '../widgets/book_page_painter.dart';
import '../widgets/table_of_contents.dart';
import '../widgets/settings_dialog.dart';

class BookReaderScreen extends StatefulWidget {
  final Book book;
  final String bookId;

  const BookReaderScreen({
    super.key,
    required this.book,
    required this.bookId,
  });

  @override
  State<BookReaderScreen> createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends State<BookReaderScreen> {
  final PageController _pageController = PageController();

  int _currentChapterIndex = 0;
  int _currentPageIndex = 0;
  bool _showControls = true;
  bool _loadedProgress = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loadedProgress) {
      _loadProgress();
    }
  }

  Future<void> _loadProgress() async {
    final settings = context.read<ReadingSettingsProvider>();
    final progress = await settings.getProgress(widget.bookId);
    if (!mounted) return;
    final safeChapter = progress.chapterIndex.clamp(0, widget.book.chapters.length - 1);
    setState(() {
      _currentChapterIndex = safeChapter;
      _currentPageIndex = progress.pageIndex;
      _loadedProgress = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_pageController.hasClients && _currentPageIndex > 0) {
        _pageController.jumpToPage(_currentPageIndex);
      }
    });
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPageIndex = page;
    });
    context.read<ReadingSettingsProvider>().updateProgress(
          widget.bookId,
          pageIndex: page,
        );
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
          context.read<ReadingSettingsProvider>().updateProgress(
                widget.bookId,
                chapterIndex: index,
                pageIndex: 0,
              );
          _pageController.jumpToPage(0);
        },
      ),
    );
  }

  void _showSettings(double currentFontSize) {
    showDialog(
      context: context,
      builder: (context) => SettingsDialog(
        currentFontSize: currentFontSize,
        onFontSizeChanged: (size) {
          context.read<ReadingSettingsProvider>().updateFontSize(size);
        },
      ),
    );
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
  }

  List<String> _splitChapterIntoPages(Chapter chapter, double fontSize) {
    // Ước tính số ký tự mỗi trang dựa trên kích thước chữ
    final charsPerPage = (1000 / (fontSize / 18)).round().clamp(200, 1600);
    final content = chapter.content.trim().isEmpty ? 'Nội dung đang cập nhật.' : chapter.content;
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

    return pages.isEmpty ? [content] : pages;
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<ReadingSettingsProvider>();
    final colorScheme = Theme.of(context).colorScheme;
    final surfaceColor = colorScheme.surface;
    final onSurfaceColor = colorScheme.onSurface;
    if (!_loadedProgress) {
      return Scaffold(
        backgroundColor: surfaceColor,
        appBar: AppBar(
          backgroundColor: surfaceColor,
          foregroundColor: onSurfaceColor,
          title: Text(widget.book.title),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final currentChapter = widget.book.chapters[_currentChapterIndex];
    final pages = _splitChapterIntoPages(currentChapter, settings.fontSize);
    final pageCount = pages.isEmpty ? 1 : pages.length;
    final safePageIndex = _currentPageIndex.clamp(0, pageCount - 1);
    if (safePageIndex != _currentPageIndex && _pageController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _pageController.hasClients) {
          _pageController.jumpToPage(safePageIndex);
          setState(() {
            _currentPageIndex = safePageIndex;
          });
          context.read<ReadingSettingsProvider>().updateProgress(
                widget.bookId,
                pageIndex: safePageIndex,
              );
        }
      });
    }

    return Scaffold(
      backgroundColor: surfaceColor,
      appBar: _showControls
          ? AppBar(
              title: Text(widget.book.title),
              backgroundColor: surfaceColor,
              foregroundColor: onSurfaceColor,
              actions: [
                const _ThemeModeButton(),
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () => _showSettings(settings.fontSize),
                  tooltip: 'Cài đặt',
                ),
              ],
            )
          : null,
      body: Stack(
        children: [
          GestureDetector(
            onTap: _toggleControls,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: pages.length,
              itemBuilder: (context, index) {
                return CustomPaint(
                  painter: BookPagePainter(
                    text: pages[index],
                    fontSize: settings.fontSize,
                    textColor: onSurfaceColor,
                    backgroundColor: surfaceColor,
                  ),
                  child: Container(),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: _ControlsBar(
          showControls: _showControls,
          surfaceColor: surfaceColor,
          primaryColor: colorScheme.primary,
          onSurfaceColor: onSurfaceColor,
          canGoPrev: _currentChapterIndex > 0,
          canGoNext: _currentChapterIndex < widget.book.chapters.length - 1,
          onPrevious: () {
            if (_currentChapterIndex > 0) {
              setState(() {
                _currentChapterIndex--;
                _currentPageIndex = 0;
              });
              context.read<ReadingSettingsProvider>().updateProgress(
                    widget.bookId,
                    chapterIndex: _currentChapterIndex,
                    pageIndex: 0,
                  );
              _pageController.jumpToPage(0);
            }
          },
          onNext: () {
            if (_currentChapterIndex < widget.book.chapters.length - 1) {
              setState(() {
                _currentChapterIndex++;
                _currentPageIndex = 0;
              });
              context.read<ReadingSettingsProvider>().updateProgress(
                    widget.bookId,
                    chapterIndex: _currentChapterIndex,
                    pageIndex: 0,
                  );
              _pageController.jumpToPage(0);
            }
          },
          onShowToc: _showTableOfContents,
        ),
      ),
      floatingActionButton: _FloatingInfoButtons(
        showControls: _showControls,
        chapterIndex: _currentChapterIndex,
        chapterCount: widget.book.chapters.length,
        pageIndex: safePageIndex,
        pageCount: pages.length,
        book: widget.book,
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class _ThemeModeButton extends StatelessWidget {
  const _ThemeModeButton();

  @override
  Widget build(BuildContext context) {
    return Consumer<ReadingSettingsProvider>(
      builder: (context, settings, _) {
        final icon = switch (settings.themeMode) {
          ThemeMode.light => Icons.light_mode_rounded,
          ThemeMode.dark => Icons.dark_mode_rounded,
          ThemeMode.system => Icons.brightness_auto_rounded,
        };

        final entries = [
          (ThemeMode.system, 'Theo hệ thống', Icons.brightness_auto_rounded),
          (ThemeMode.light, 'Sáng', Icons.light_mode_rounded),
          (ThemeMode.dark, 'Tối', Icons.dark_mode_rounded),
        ];

        return PopupMenuButton<ThemeMode>(
          tooltip: 'Chế độ giao diện',
          icon: Icon(icon),
          onSelected: settings.updateThemeMode,
          itemBuilder: (context) => entries
              .map(
                (entry) => PopupMenuItem<ThemeMode>(
                  value: entry.$1,
                  child: Row(
                    children: [
                      Icon(entry.$3, color: Theme.of(context).iconTheme.color),
                      const SizedBox(width: 12),
                      Text(entry.$2),
                      const Spacer(),
                      if (settings.themeMode == entry.$1) const Icon(Icons.check_rounded),
                    ],
                  ),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class _ControlsBar extends StatelessWidget {
  final bool showControls;
  final Color surfaceColor;
  final Color primaryColor;
  final Color onSurfaceColor;
  final bool canGoPrev;
  final bool canGoNext;
  final VoidCallback onShowToc;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const _ControlsBar({
    required this.showControls,
    required this.surfaceColor,
    required this.primaryColor,
    required this.onSurfaceColor,
    required this.canGoPrev,
    required this.canGoNext,
    required this.onShowToc,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      height: showControls ? kBottomNavigationBarHeight + 16 : 0,
      child: IgnorePointer(
        ignoring: !showControls,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 250),
          opacity: showControls ? 1 : 0,
          child: BottomNavigationBar(
            backgroundColor: surfaceColor,
            selectedItemColor: primaryColor,
            unselectedItemColor: onSurfaceColor.withValues(alpha: 0.8),
            currentIndex: 0,
            onTap: (index) {
              switch (index) {
                case 0:
                  onShowToc();
                  break;
                case 1:
                  if (canGoPrev) onPrevious();
                  break;
                case 2:
                  if (canGoNext) onNext();
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
                  color: canGoPrev ? null : onSurfaceColor.withValues(alpha: 0.3),
                ),
                label: 'Chương trước',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.arrow_forward,
                  color: canGoNext ? null : onSurfaceColor.withValues(alpha: 0.3),
                ),
                label: 'Chương sau',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FloatingInfoButtons extends StatelessWidget {
  final bool showControls;
  final int chapterIndex;
  final int chapterCount;
  final int pageIndex;
  final int pageCount;
  final Book book;

  const _FloatingInfoButtons({
    required this.showControls,
    required this.chapterIndex,
    required this.chapterCount,
    required this.pageIndex,
    required this.pageCount,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 300),
      offset: showControls ? Offset.zero : const Offset(0, 0.4),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: showControls ? 1 : 0,
        child: Padding(
          padding: const EdgeInsets.only(right: 6, bottom: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FloatingActionButton.small(
                heroTag: 'progress',
                onPressed: () {
                  final progress =
                      (chapterIndex / (chapterCount == 0 ? 1 : chapterCount) * 100).toStringAsFixed(0);
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
                          Text('Sách: ${book.title}'),
                          Text('Tác giả: ${book.author}'),
                          const SizedBox(height: 10),
                          Text('Chương ${chapterIndex + 1}/$chapterCount'),
                          Text('Trang ${pageIndex + 1}/$pageCount'),
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
        ),
      ),
    );
  }
}
