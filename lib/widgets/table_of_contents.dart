import 'package:flutter/material.dart';
import '../models/book.dart';

class TableOfContentsDialog extends StatelessWidget {
  final Book book;
  final int currentChapterIndex;
  final Function(int) onChapterSelected;

  const TableOfContentsDialog({
    super.key,
    required this.book,
    required this.currentChapterIndex,
    required this.onChapterSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Dialog(
      backgroundColor: colorScheme.surface,
      elevation: 16,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 24,
              spreadRadius: 2,
            ),
          ],
        ),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mục lục',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close_rounded, color: colorScheme.onSurface),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            Divider(thickness: 1, color: colorScheme.outlineVariant),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: book.chapters.length,
                itemBuilder: (context, index) {
                  final chapter = book.chapters[index];
                  final isCurrentChapter = index == currentChapterIndex;

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: isCurrentChapter
                          ? colorScheme.primary.withValues(alpha: 0.08)
                          : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            isCurrentChapter ? colorScheme.primary : Colors.grey[400],
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: isCurrentChapter ? Colors.white : colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      title: Text(
                        chapter.title,
                        style: TextStyle(
                          fontWeight: isCurrentChapter
                              ? FontWeight.bold
                              : FontWeight.w500,
                          color:
                              isCurrentChapter ? colorScheme.primary : colorScheme.onSurface,
                          fontSize: 15,
                        ),
                      ),
                      trailing: isCurrentChapter
                          ? Icon(Icons.play_arrow_rounded, color: colorScheme.primary, size: 28)
                          : Icon(Icons.arrow_forward_ios_rounded, color: colorScheme.onSurface.withValues(alpha: 0.6), size: 16),
                      onTap: () {
                        onChapterSelected(index);
                        Navigator.of(context).pop();
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
