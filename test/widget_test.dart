// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bt2/widgets/settings_dialog.dart';

void main() {
  testWidgets('Settings dialog applies updated font size', (tester) async {
    double selectedSize = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: SettingsDialog(
          currentFontSize: 18,
          onFontSizeChanged: (value) => selectedSize = value,
        ),
      ),
    );

    // Increase font size using the "+" icon.
    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pumpAndSettle();

    // Apply the change.
    await tester.tap(find.text('Áp dụng'));
    await tester.pumpAndSettle();

    expect(selectedSize, greaterThan(18));
  });
}
