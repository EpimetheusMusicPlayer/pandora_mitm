import 'package:flutter/material.dart';

class BrowserWarning extends StatelessWidget {
  const BrowserWarning({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final textStyle =
        textTheme.subtitle1!.copyWith(color: textTheme.displaySmall!.color);
    return DefaultTextStyle(
      style: textStyle,
      child: IconTheme(
        data: IconThemeData(color: textStyle.color),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.warning_amber_rounded),
                SizedBox(width: 8),
                Text('Multithreading is unavailable in Web builds'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.info_outline_rounded),
                SizedBox(width: 8),
                Text(
                  'Some browsers prohibit plaintext WebSocket connections',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
