class Book {
  final String title;
  final String author;
  final List<Chapter> chapters;

  Book({required this.title, required this.author, required this.chapters});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'] as String,
      author: json['author'] as String,
      chapters: (json['chapters'] as List)
          .map((chapter) => Chapter.fromJson(chapter))
          .toList(),
    );
  }
}

class Chapter {
  final String title;
  final String content;

  Chapter({required this.title, required this.content});

  factory Chapter.fromJson(Map<String, dynamic> json) {
    return Chapter(
      title: json['title'] as String,
      content: json['content'] as String,
    );
  }
}

class BookInfo {
  final String title;
  final String author;
  final int chapters;
  final String path;

  BookInfo({
    required this.title,
    required this.author,
    required this.chapters,
    required this.path,
  });
}
