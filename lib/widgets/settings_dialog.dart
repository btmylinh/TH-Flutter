import 'package:flutter/material.dart';

class SettingsDialog extends StatefulWidget {
  final double currentFontSize;
  final Function(double) onFontSizeChanged;

  const SettingsDialog({
    super.key,
    required this.currentFontSize,
    required this.onFontSizeChanged,
  });

  @override
  State<SettingsDialog> createState() => _SettingsDialogState();
}

class _SettingsDialogState extends State<SettingsDialog> {
  late double _fontSize;

  @override
  void initState() {
    super.initState();
    _fontSize = widget.currentFontSize;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cài đặt',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const Divider(thickness: 1),
            const SizedBox(height: 20),
            Text(
              'Kích thước chữ',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_rounded),
                  onPressed: _fontSize > 12
                      ? () {
                          setState(() {
                            _fontSize -= 2;
                          });
                        }
                      : null,
                ),
                Expanded(
                  child: Slider(
                    value: _fontSize,
                    min: 12,
                    max: 32,
                    divisions: 10,
                    label: _fontSize.round().toString(),
                    onChanged: (value) {
                      setState(() {
                        _fontSize = value;
                      });
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_rounded),
                  onPressed: _fontSize < 32
                      ? () {
                          setState(() {
                            _fontSize += 2;
                          });
                        }
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Ví dụ văn bản với kích thước ${_fontSize.round()}',
                style: TextStyle(fontSize: _fontSize),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  widget.onFontSizeChanged(_fontSize);
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.check_rounded),
                label: const Text('Áp dụng'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
