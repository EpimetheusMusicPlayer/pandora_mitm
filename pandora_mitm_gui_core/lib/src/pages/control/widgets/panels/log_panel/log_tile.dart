import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class LogTile extends StatelessWidget {
  final LogRecord record;

  const LogTile({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return SelectableText.rich(
      TextSpan(
        style: const TextStyle(fontFamily: 'Jetbrains Mono'),
        children: [
          TextSpan(text: '[${record.level.name}] '),
          TextSpan(
            text: record.loggerName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: ': ${record.message}'),
        ],
      ),
    );
  }
}
