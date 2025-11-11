import 'package:flutter/material.dart';

class BookPagePainter extends CustomPainter {
  final String text;
  final double fontSize;
  final Color textColor;
  final Color backgroundColor;

  BookPagePainter({
    required this.text,
    required this.fontSize,
    required this.textColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Vẽ nền
    final backgroundPaint = Paint()..color = backgroundColor;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      backgroundPaint,
    );

    // Tạo TextPainter để vẽ văn bản
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          height: 1.6,
          fontFamily: 'Serif',
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.justify,
    );

    // Thiết lập chiều rộng tối đa cho văn bản (với padding)
    final maxWidth = size.width - 80; // 40px padding mỗi bên
    textPainter.layout(maxWidth: maxWidth);

    // Vẽ văn bản với padding
    final offset = Offset(40, 60);
    textPainter.paint(canvas, offset);

    // Vẽ số trang (trang trí)
    _drawPageNumber(canvas, size);
  }

  void _drawPageNumber(Canvas canvas, Size size) {
    // Vẽ đường trang trí ở đầu trang
    final decorPaint = Paint()
      ..color = textColor.withValues(alpha: 0.3)
      ..strokeWidth = 1;

    canvas.drawLine(Offset(40, 40), Offset(size.width - 40, 40), decorPaint);

    // Vẽ đường trang trí ở cuối trang
    canvas.drawLine(
      Offset(40, size.height - 40),
      Offset(size.width - 40, size.height - 40),
      decorPaint,
    );
  }

  @override
  bool shouldRepaint(BookPagePainter oldDelegate) {
    return oldDelegate.text != text ||
        oldDelegate.fontSize != fontSize ||
        oldDelegate.textColor != textColor ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
