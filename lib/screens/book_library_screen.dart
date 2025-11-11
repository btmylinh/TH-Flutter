import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/book_service.dart';
import 'book_reader_screen.dart';
import '../theme/theme_controller.dart';

class BookLibraryScreen extends StatefulWidget {
  const BookLibraryScreen({super.key});

  @override
  State<BookLibraryScreen> createState() => _BookLibraryScreenState();
}

class _BookLibraryScreenState extends State<BookLibraryScreen> {
  final BookService _bookService = BookService();
  List<BookInfo> _books = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  Future<void> _loadBooks() async {
    try {
      // Load danh sách sách
      final bookInfos = await _bookService.getBookList();
      setState(() {
        _books = bookInfos;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _openBook(String bookPath) async {
    // Hiển thị loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final book = await _bookService.loadBook(bookPath);

      if (!mounted) return;

      // Đóng loading dialog
      Navigator.of(context).pop();

      // Mở màn hình đọc sách
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => BookReaderScreen(book: book)),
      );
    } catch (e) {
      if (!mounted) return;

      // Đóng loading dialog
      Navigator.of(context).pop();

      // Hiển thị lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi khi tải sách: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thư Viện Sách'),
        centerTitle: true,
        elevation: 0,
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
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(
              'Đang tải thư viện...',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 72,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 20),
              const Text(
                'Lỗi khi tải thư viện',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(_errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _errorMessage = null;
                  });
                  _loadBooks();
                },
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      );
    }

    if (_books.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book_rounded, size: 64, color: Colors.grey),
            SizedBox(height: 20),
            Text(
              'Chưa có sách nào',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _books.length,
      itemBuilder: (context, index) {
        final book = _books[index];
        return _buildBookCard(book);
      },
    );
  }

  Widget _buildBookCard(BookInfo book) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: InkWell(
        onTap: () => _openBook(book.path),
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon sách
              Container(
                width: 84,
                height: 108,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary.withValues(alpha: 0.65),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.menu_book_rounded, size: 42, color: Colors.white),
              ),
              const SizedBox(width: 16),
              // Thông tin sách
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.person_rounded, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          book.author,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.auto_stories_rounded, size: 16, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          '${book.chapters} chương',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Icon mũi tên
              const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
