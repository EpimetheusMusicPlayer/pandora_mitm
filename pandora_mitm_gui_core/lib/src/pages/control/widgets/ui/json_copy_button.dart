import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class JsonCopyButton extends StatelessWidget {
  final Object? jsonEncodable;

  const JsonCopyButton({
    super.key,
    required this.jsonEncodable,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.copy),
      tooltip: 'Copy JSON',
      onPressed: () => Clipboard.setData(
        ClipboardData(
          text: const JsonEncoder.withIndent('    ').convert(jsonEncodable),
        ),
      ),
    );
  }
}
